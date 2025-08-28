# Apache Log Automation Script

This repository contains a simple **Bash automation script** to manage Apache2 web server logs and upload them to an **AWS S3 bucket**.

## 📌 Features
- Updates all system packages  
- Installs **Apache2** if not already installed  
- Ensures Apache2 service is **running** and **enabled on boot**  
- Archives Apache2 log files with a **timestamped filename**  
- Uploads the archive to a specified **AWS S3 bucket**  

---

## 🚀 Prerequisites
Before running this script, make sure you have:

1. **Ubuntu/Debian system** with `bash`
2. **AWS CLI installed and configured** (`aws configure`)
3. Proper IAM role or AWS credentials with **S3 write access**
4. `tar`, `systemctl`, and `dpkg-query` utilities installed (default in Ubuntu)

---

## ⚙️ Script Variables
Inside the script, you can configure:

```bash
s3_bucket=upgrad-saurav    # S3 bucket name
myname=saurav              # Used for naming archives
timestamp=$(date '+%d%m%Y-%H%M%S')  # Timestamp format
```

---

## 🛠️ Usage

1. Clone this repository:
   ```bash
   git clone https://github.com/<your-username>/<repo-name>.git
   cd <repo-name>
   ```

2. Make the script executable:
   ```bash
   chmod +x automation.sh
   ```

3. Run the script:
   ```bash
   ./automation.sh
   ```

---

## 📂 Output
- Archives of Apache logs are stored in `/tmp`:
  ```
  /tmp/saurav-httpd-logs-<timestamp>.tar
  ```
- Archives are uploaded to your **S3 bucket**:
  ```
  s3://upgrad-saurav/saurav-httpd-logs-<timestamp>.tar
  ```

---

## ⏰ Automation (Optional)
You can schedule this script using `cron` to run automatically. Example:  
```bash
sudo crontab -e
```

Add the following line to run the script daily at midnight:
```
0 0 * * * /path/to/automation.sh
```

---

## 📜 License
This project is open source. Feel free to modify and use it as per your needs.
