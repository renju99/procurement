# Quick Start Guide

## Step 1: Setup Backend Server (Local Testing)

1. **Navigate to the project directory:**
   ```bash
   cd standalone-form
   ```

2. **Install dependencies:**
   ```bash
   npm install
   ```

3. **Start the server:**
   ```bash
   npm start
   ```

   You should see:
   ```
   Server is running on port 3000
   Health check: http://localhost:3000/api/health
   Form endpoint: http://localhost:3000/api/submit
   ```

4. **Test the server:**
   Open `http://localhost:3000/api/health` in your browser. You should see:
   ```json
   {"status":"ok","timestamp":"..."}
   ```

## Step 2: Test the Form Locally

1. **Open the form:**
   - Open `vendor-registration-form.html` (or `index.html` for simple form) in your browser, OR
   - Serve it with a simple HTTP server:
     ```bash
     # Using Python
     python -m http.server 8000
     
     # Using Node.js (if you have http-server installed)
     npx http-server -p 8000
     ```
   - Then visit: `http://localhost:8000/vendor-registration-form.html`

2. **Fill out and submit the form:**
   - The form will automatically use `http://localhost:3000/api/submit` when running locally
   - Check the `uploads/` folder for uploaded files (up to 6 files per submission)
   - Check `submissions.json` for form data

## Step 3: Deploy to GitHub Pages

1. **Update API URL in `vendor-registration-form.html`:**
   
   Find this section (around line 1606):
   ```javascript
   const apiUrl = window.location.hostname === 'localhost' || window.location.hostname === '127.0.0.1'
       ? 'http://localhost:3000/api/submit'
       : 'https://your-backend-server.com/api/submit';
   ```
   
   Replace `'https://your-backend-server.com/api/submit'` with your actual backend URL.

2. **Push to GitHub:**
   ```bash
   git init
   git add vendor-registration-form.html
   git commit -m "Add vendor registration form"
   git branch -M main
   git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPO.git
   git push -u origin main
   ```

3. **Enable GitHub Pages:**
   - Go to repository → Settings → Pages
   - Source: Deploy from a branch
   - Branch: `main` / `/ (root)`
   - Click Save

4. **Your form is live at:**
   `https://YOUR_USERNAME.github.io/YOUR_REPO/vendor-registration-form.html`
   
   (Or if you set `index.html` as the main file, it will be at the root URL)

## Step 4: Deploy Backend Server

Choose one of these options:

### Option 1: Railway (Easiest)

1. Go to [railway.app](https://railway.app)
2. Sign up/login
3. New Project → Deploy from GitHub repo
4. Select your repository
5. Set root directory: `standalone-form`
6. Deploy!
7. Copy the generated URL and update it in `index.html`

### Option 2: Render

1. Go to [render.com](https://render.com)
2. New → Web Service
3. Connect GitHub repository
4. Settings:
   - Build Command: `npm install`
   - Start Command: `npm start`
5. Deploy!
6. Copy the URL and update it in `index.html`

### Option 3: Your Own Server

1. SSH into your server
2. Clone repository
3. Install Node.js (v14+)
4. Run:
   ```bash
   cd standalone-form
   npm install
   npm install -g pm2
   pm2 start server.js --name form-server
   pm2 save
   ```
5. Set up Nginx reverse proxy (see README.md)
6. Update API URL in `index.html`

## Troubleshooting

**Form shows error when submitting:**
- Make sure backend server is running
- Check API URL is correct
- Check browser console for CORS errors
- Verify backend is accessible from the internet

**Files not uploading:**
- Check file size (max 10MB)
- Verify file type is allowed
- Check server logs
- Ensure `uploads/` directory exists and is writable

**Need help?**
- Check the full README.md for detailed instructions
- Review server logs for error messages

