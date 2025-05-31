FROM node:alpine

# Set working directory
WORKDIR /app

# Copy package files and install dependencies
COPY package*.json /app/
RUN npm install --production

# Copy all remaining source files
COPY . /app/

# Expose port
EXPOSE 3000

# Start the application
CMD ["npm", "start"]

