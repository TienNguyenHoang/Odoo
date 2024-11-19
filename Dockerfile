# Sử dụng Python 3.12 làm base image
FROM python:3.12-slim

# Đặt thư mục làm việc
WORKDIR /usr/src/app

# Cài đặt các gói hệ thống cần thiết
RUN apt-get update && \
    apt-get install -y \
    gcc \
    libev-dev \
    libevent-dev \
    build-essential \
    libssl-dev \
    libxml2-dev \
    libxslt-dev \
    libpq-dev \
    libldap2-dev \
    libsasl2-dev \
    python3-dev \
    wget \
    fontconfig && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Cài đặt wkhtmltopdf từ kho Ubuntu chính thức
RUN apt-get update && \
    apt-get install -y wkhtmltopdf

# Copy các file cần thiết vào container
COPY requirements.txt ./requirements.txt

# Cài đặt các gói Python
RUN pip install --upgrade pip setuptools wheel && \
    pip install -r requirements.txt


# Copy toàn bộ mã nguồn vào container
COPY . .

COPY ./odoo/addons /srv/odoo/addons

# Expose port (nếu chạy trên một cổng cụ thể, ví dụ: 8069 cho Odoo)
EXPOSE 8069

# Cấu hình đường dẫn môi trường
ENV PATH="/usr/src/app:${PATH}"

# Copy tệp cấu hình odoo.conf
COPY odoo.conf /etc/odoo/odoo.conf

# Chạy ứng dụng
CMD ["python", "/usr/src/app/odoo-bin", "--config", "/etc/odoo/odoo.conf"]
