# =========================
# 构建阶段（Build Stage）
# =========================
FROM node:20.20.2-alpine AS builder

# 容器内工作目录
WORKDIR /app

# 拷贝依赖描述文件，利用 Docker 缓存
COPY package.json pnpm-lock.yaml ./

# 启用并安装 pnpm（版本与 packageManager 保持一致）
RUN corepack enable && corepack prepare pnpm@10.15.1 --activate

# 安装所有依赖（包含 devDependencies，用于 TypeScript 编译）
RUN pnpm install --frozen-lockfile

# 拷贝项目源码
COPY . .

# 编译 TypeScript → dist/
RUN pnpm build


# =========================
# 运行阶段（Runtime Stage）
# =========================
FROM node:20.20.2-alpine

# 工作目录
WORKDIR /app

# 只拷贝运行阶段需要的内容
COPY --from=builder /app/dist ./dist
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package.json ./package.json

# 暴露端口（与你的 app.ts 保持一致）
EXPOSE 3000

# 健康检查（Docker / 云平台使用）
HEALTHCHECK --interval=30s --timeout=5s --retries=3 \
  CMD wget -qO- http://localhost:3000/health || exit 1

# 启动服务
CMD ["node", "dist/app.js"]
