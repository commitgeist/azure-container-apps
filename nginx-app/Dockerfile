FROM nginx:alpine

# Copiar arquivos estáticos customizados (opcional)
COPY index.html /usr/share/nginx/html/

# Expor porta 80
EXPOSE 80

# Comando padrão do nginx
CMD ["nginx", "-g", "daemon off;"]

