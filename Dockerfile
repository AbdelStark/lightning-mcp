# Generated by https://smithery.ai. See: https://smithery.ai/docs/config#dockerfile
# Use a Node.js image
FROM node:18-alpine AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies
COPY package.json package-lock.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application
COPY . .

# Build the application
RUN npm run build

# Use a lightweight node image to run the application
FROM node:18-alpine

# Set the working directory
WORKDIR /app

# Copy the build artifacts from the build stage
COPY --from=build /app/dist ./dist
COPY --from=build /app/package.json ./
COPY --from=build /app/package-lock.json ./
COPY --from=build /app/.env.example ./env

# Install only production dependencies
RUN npm install --production

# Expose the port the app runs on
EXPOSE 3000

# Set environment variables (ensure to provide actual keys in production)
ENV NODE_ENV=production
ENV PORT=3000
ENV LNBITS_URL="https://demo.lnbits.com"
ENV LNBITS_ADMIN_KEY="your_admin_key"
ENV LNBITS_READ_KEY="your_read_key"

# Start the application
CMD ["node", "dist/index.js"]
