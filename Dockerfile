# Use Nginx as base image
FROM nginx:alpine

# Copy HTML files into Nginx default folder
COPY app /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
