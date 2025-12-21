# Test Form Submission with Sample Data

This script submits a complete test form with sample data and attaches the PDF file to all file upload fields.

## Quick Start

1. **Ensure the PDF file is available:**
   ```powershell
   # Copy PDF to standalone-form directory
   Copy-Item "BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf" -Destination "standalone-form\"
   ```

2. **Ensure backend is running:**
   ```powershell
   docker ps --filter name=vendor-form-backend
   # If not running:
   docker-compose up -d
   ```

3. **Run the test:**
   ```powershell
   cd standalone-form
   .\test-submission.ps1
   ```

   Or manually:
   ```powershell
   cd standalone-form
   npm install form-data
   node test-submission.js
   ```

## What It Does

- ✅ Fills all 12 sections with sample data
- ✅ Attaches the PDF file to all 6 file upload fields:
  - Trade License
  - Owner/Partners Passport Copies
  - Bank Statement
  - VAT Certificate
  - Company Profile
  - Financial Statement
- ✅ Submits to `http://localhost:3001/api/submit`
- ✅ Shows success/error messages

## Sample Data Included

- **Company:** Test Company LLC
- **Location:** Dubai, UAE
- **Services:** MEP, Civil, Mechanical, FLS, ELV services
- **All required fields:** Filled with realistic test data

## Check Results

After submission, check:
- **Form data:** `standalone-form/data/submissions.json`
- **Uploaded files:** `standalone-form/uploads/`

## Troubleshooting

**Error: PDF file not found**
- Copy the PDF file to `standalone-form/` directory
- Or update the path in `test-submission.js`

**Error: Cannot connect to server**
- Ensure Docker container is running: `docker ps`
- Start it: `docker-compose up -d`

**Error: Module not found**
- Run: `npm install form-data` in the `standalone-form` directory

