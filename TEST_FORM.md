# Testing the Vendor Registration Form

## Quick Test Guide

### 1. Verify Backend is Running

```bash
# Check container status
docker ps --filter name=vendor-form-backend

# Test health endpoint
curl http://localhost:3001/api/health
```

Expected response:
```json
{"status":"ok","timestamp":"2025-12-10T19:31:38.766Z"}
```

### 2. Open the Form

**Option A: Direct file open**
- Open `vendor-registration-form.html` directly in your browser
- The form will automatically use `http://localhost:3001/api/submit` when running locally

**Option B: Serve with HTTP server (recommended)**
```bash
# Using Python
python -m http.server 8000

# Using Node.js
npx http-server -p 8000
```
Then visit: `http://localhost:8000/vendor-registration-form.html`

### 3. Test Form Submission

1. Fill out the form with test data
2. Upload some test files (optional)
3. Click "Submit Registration"
4. You should see: "Registration submitted successfully!"

### 4. Verify Data Storage

**Check uploads:**
```bash
# Windows PowerShell
dir standalone-form\uploads

# Linux/Mac
ls -la standalone-form/uploads/
```

**Check submissions:**
```bash
# View submissions JSON
cat standalone-form/data/submissions.json

# Or on Windows
type standalone-form\data\submissions.json
```

## Form Features

✅ **12 Sections:**
1. Vendor Name & Address
2. Company Details
3. Owner / Partners
4. Bank Accounts
5. References
6. Key Contacts
7. Required Documents (with file uploads)
8. Insurances
9. ESG & QHSE Requirements
10. Payment Terms
11. Nature of Business (categorized services)
12. Disclaimer and Declaration

✅ **File Uploads:**
- Trade License
- Owner/Partners Passport Copies
- Bank Statement
- VAT Certificate
- Company Profile (optional)
- Financial Statement (optional)

✅ **Categorized Services:**
- MEP (Mechanical, Electrical, Plumbing)
- Civil
- Mechanical
- FLS (Fire Life Safety)
- ELV (Extra Low Voltage)
- Other Specialized Services

## Troubleshooting

**Form won't submit:**
- Check backend is running: `docker ps`
- Check browser console (F12) for errors
- Verify API URL in form matches your backend port

**Files not uploading:**
- Check file size (max 10MB)
- Check file type is allowed (.pdf, .doc, .docx, .jpg, .jpeg, .png)
- Check `standalone-form/uploads/` directory exists and is writable

**Backend errors:**
- View logs: `docker logs vendor-form-backend`
- Check port 3001 is available
- Verify Docker volume mounts are working

## Next Steps

1. ✅ Test locally - Everything is ready!
2. ⏭️ Deploy backend to production server
3. ⏭️ Update API URL in form for production
4. ⏭️ Deploy form to GitHub Pages
5. ⏭️ Configure CORS for your domain

