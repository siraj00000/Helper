Got it — you want the `README.md` to walk through the **entire AWS S3 setup flow**: from creating the bucket to setting up permissions and integrating with your Node.js app.

Here’s a complete and clear **"S3 Integration Guide"** section to include in your existing README:

---

## ☁️ AWS S3 Integration Guide

This section describes how to **set up S3** on AWS and integrate it with your Node.js backend for uploading and accessing images or files.

---

### 🔧 Step 1: Create an S3 Bucket

1. Go to the [AWS S3 Console](https://s3.console.aws.amazon.com/s3/)
2. Click **"Create bucket"**
3. Enter a unique **bucket name** (e.g., `<bucket-name>`)
4. Choose your preferred AWS region (e.g., `us-east-2`)
5. In **"Object Ownership"**, select:

   * ✅ Bucket owner enforced (recommended)
6. **Uncheck** “Block all public access” **(if you want files publicly accessible)**
7. Click **Create bucket**

---

### 🔐 Step 2: Create a Public Read Bucket Policy (Optional)

If you want uploaded files (like profile images) to be publicly accessible via URL, add this bucket policy:

1. Go to the **Permissions** tab of your bucket
2. Scroll to **Bucket policy** → Click **Edit**
3. Paste this (modify the folder if needed):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowPublicReadAccess",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::<bucket-name>/profile-pictures/*"
    }
  ]
}
```

4. Save the policy

> ⚠️ If you cannot save, go to the bucket’s **Block Public Access** settings and uncheck `Block public access to buckets and objects granted through public bucket policies`.

---

### 👤 Step 3: Create an IAM User for S3 Access

1. Go to the [IAM Console](https://console.aws.amazon.com/iam/)
2. Click **Users → Add user**
3. Name: `s3-uploader` (or any name)
4. Access type: ✅ **Programmatic access**
5. Click **Next**

---

### 🛡️ Step 4: Create a Custom Policy for the IAM User

1. In the **Set permissions** step, click **"Attach policies directly"**
2. Click **Create policy → JSON**
3. Paste the following policy (replace bucket name):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "S3UploadPermissions",
      "Effect": "Allow",
      "Action": [
        "s3:PutObject",
        "s3:GetObject",
        "s3:ListBucket"
      ],
      "Resource": [
        "arn:aws:s3:::<bucket-name>",
        "arn:aws:s3:::<bucket-name>/*"
      ]
    }
  ]
}
```

4. Review → Name it `S3UploadPolicy`
5. Attach this policy to the IAM user

---

### 🔑 Step 5: Save AWS Credentials

After creating the user, you'll get:

* **Access Key ID**
* **Secret Access Key**

Keep these safe — you'll add them to your `.env` file.

---

### 📄 Step 6: Add AWS Credentials to `.env`

```env
AWS_ACCESS_KEY=<your_access_key_id>
AWS_SECRET_KEY=<your_secret_access_key>
AWS_REGION=us-east-2
AWS_BUCKET_NAME=<bucket-name>
```

---

### 📦 Step 7: Upload Files via UploadManager (Node.js)

Use the `UploadManager` class in the backend to upload single or multiple images:

```ts
await uploadManager.uploadSingleImage(file, "profile-pictures");

await uploadManager.uploadMultipleImages(files, "chat-uploads");
```

---

### 🔗 Resulting Public URL Format

```
https://<bucket-name>.s3.us-east-2.amazonaws.com/profile-pictures/<unique-file-name>.jpg
```
