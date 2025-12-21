const FormData = require('form-data');
const fs = require('fs');
const path = require('path');
const http = require('http');

// Sample form data
const sampleData = {
    // Section 1: Vendor Name & Address
    companyName: 'Test Company LLC',
    telephone: '+971501234567',
    poBox: '12345',
    country: 'UAE',
    emirates: 'Dubai',
    headOfficeAddress: 'Business Bay, Dubai, UAE',
    'servingEmirates[]': ['Dubai', 'Abu Dhabi'],
    helpDeskEmail: 'support@testcompany.ae',
    helpDeskContact: '+971501234567',
    website: 'https://www.testcompany.ae',
    
    // Section 2: Company Details
    tradeLicenseNumber: 'TL123456789',
    tradeLicenseIssueDate: '2020-01-15',
    tradeLicenseValidity: '2025-01-15',
    issuingAuthority: 'Dubai Department of Economic Development',
    vatCertificate: 'VAT123456789',
    
    // Section 3: Owner / Partners
    ownerName: 'John Smith',
    partnerName: 'Jane Doe',
    
    // Section 4: Bank Accounts
    accountName: 'Test Company LLC',
    bankName: 'Emirates NBD',
    bankBranch: 'Dubai Main Branch',
    accountNumber: '1234567890',
    ibanNumber: 'AE123456789012345678901',
    accountCurrency: 'AED',
    
    // Section 5: References
    reference01: 'ABC Corporation / 60 Days / Ahmed Ali / +971501111111',
    reference02: 'XYZ Industries / 90 Days / Sarah Johnson / +971502222222',
    reference03: 'DEF Trading / 45 Days / Mohammed Hassan / +971503333333',
    reference04: 'GHI Services / 30 Days / Fatima Ahmed / +971504444444',
    reference05: 'JKL Group / 60 Days / Omar Khalid / +971505555555',
    
    // Section 6: Key Contacts
    contact01Name: 'John Smith',
    contact01Email: 'ceo@testcompany.ae',
    contact01Phone: '+971501234567',
    contact02Name: 'Jane Doe',
    contact02Email: 'finance@testcompany.ae',
    contact02Phone: '+971501234568',
    contact03Name: 'Mike Johnson',
    contact03Email: 'operations@testcompany.ae',
    contact03Phone: '+971501234569',
    contact04Name: 'Sarah Williams',
    contact04Email: 'sales@testcompany.ae',
    contact04Phone: '+971501234570',
    contact05Name: 'David Brown',
    contact05Email: 'salesexec@testcompany.ae',
    contact05Phone: '+971501234571',
    
    // Section 7: Required Documents (checkboxes)
    docTradeLicense: 'on',
    docOwnerPassport: 'on',
    docBankStatement: 'on',
    docVatCertificate: 'on',
    docCompanyProfile: 'on',
    docFinancialStatement: 'on',
    
    // Section 8: Insurances
    publicLiability: 'Yes',
    employerLiability: 'Yes',
    workmanCompensation: 'Yes',
    contractorsRiskInsurance: 'Yes',
    
    // Section 9: ESG & QHSE Requirements
    imsCertification: 'Yes',
    ecovadisAssessment: 'Yes',
    hazardIdentification: 'Yes',
    qualityPolicy: 'Yes',
    healthSafetyPolicy: 'Yes',
    environmentPolicy: 'Yes',
    energyPolicy: 'Yes',
    laborStandards: 'Yes',
    commitmentDisclosure: 'Yes',
    supplierCode: 'Yes',
    trainingPolicy: 'Yes',
    riskAssessment: 'Yes',
    'employeesRights[]': ['Notice Boards', 'Intranet', 'Written Contracts'],
    overtimeVoluntary: 'Yes',
    weeklyWorkingHours: '48',
    youngestEmploymentAge: '18',
    
    // Section 10: Payment Terms
    creditPeriod: '90 Days',
    
    // Section 11: Nature of Business
    'materialsSupply[]': ['HVAC Items', 'Electrical Items', 'Mechanical Items'],
    'amcServices[]': [
        'AC / Chiller replacement',
        'Ducting Works',
        'Water proofing',
        'Painting Works',
        'Motors & Pumps Repairing',
        'Fire Alarm',
        'BMS',
        'CCTV Maintenance'
    ],
    'manpowerSupply[]': ['Male Security Guard', 'HVAC Technician', 'Electrician'],
    otherServices: 'General maintenance and support services',
    
    // Section 12: Disclaimer and Declaration
    authorizedPersonName: 'John Smith',
    authorizedPersonContact: '+971501234567',
    authorizedPersonEmail: 'john.smith@testcompany.ae'
};

async function submitTestForm() {
    const formData = new FormData();
    
    // Add all text fields
    Object.keys(sampleData).forEach(key => {
        const value = sampleData[key];
        if (Array.isArray(value)) {
            value.forEach(v => formData.append(key, v));
        } else {
            formData.append(key, value);
        }
    });
    
    // Get the PDF file path - use the attached PDF file
    let pdfPath = path.join(__dirname, 'BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf');
    if (!fs.existsSync(pdfPath)) {
        pdfPath = path.join(__dirname, '..', 'BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf');
    }
    if (!fs.existsSync(pdfPath)) {
        pdfPath = path.join(__dirname, 'test-pdf.pdf');
    }
    
    if (!fs.existsSync(pdfPath)) {
        console.error('PDF file not found. Tried:');
        console.error('  - ' + path.join(__dirname, 'BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf'));
        console.error('  - ' + path.join(__dirname, '..', 'BERKELEY ONLINE VENDOR REGISTRATION FORM.pdf'));
        console.error('  - ' + path.join(__dirname, 'test-pdf.pdf'));
        console.log('\nPlease ensure the PDF file is in the project directory');
        process.exit(1);
    }
    
    // Add PDF file to all file upload fields
    const pdfStream = fs.createReadStream(pdfPath);
    const pdfStats = fs.statSync(pdfPath);
    
    console.log('Attaching PDF to all file upload fields...');
    console.log(`PDF file size: ${(pdfStats.size / 1024 / 1024).toFixed(2)} MB`);
    
    // Attach PDF to all required file fields
    formData.append('tradeLicense', pdfStream, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    // For other files, we'll create copies of the stream
    // Note: In a real scenario, you'd have different files, but for testing we'll use the same PDF
    const pdfStream2 = fs.createReadStream(pdfPath);
    formData.append('ownerPassport', pdfStream2, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    const pdfStream3 = fs.createReadStream(pdfPath);
    formData.append('bankStatement', pdfStream3, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    const pdfStream4 = fs.createReadStream(pdfPath);
    formData.append('vatCertificate', pdfStream4, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    const pdfStream5 = fs.createReadStream(pdfPath);
    formData.append('companyProfile', pdfStream5, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    const pdfStream6 = fs.createReadStream(pdfPath);
    formData.append('financialStatement', pdfStream6, {
        filename: 'BERKELEY_ONLINE_VENDOR_REGISTRATION_FORM.pdf',
        contentType: 'application/pdf'
    });
    
    // Add optional file fields (using same PDF for testing)
    // Note: We need to create new streams for each file field
    const optionalFields = [
        'workmanCompFile', 'publicLiabilityFile', 'contractorsRiskFile', 
        'employerLiabilityFile', 'imsCertFile', 'ecovadisFile', 'hazardIdFile',
        'qualityPolicyFile', 'healthSafetyPolicyFile', 'environmentPolicyFile',
        'energyPolicyFile', 'laborStandardsFile', 'commitmentFile', 
        'supplierCodeFile', 'trainingPolicyFile', 'riskAssessmentFile'
    ];
    
    console.log(`Attaching PDF to ${optionalFields.length} optional file fields...`);
    optionalFields.forEach((field, index) => {
        const stream = fs.createReadStream(pdfPath);
        formData.append(field, stream, {
            filename: `test-${field}.pdf`,
            contentType: 'application/pdf'
        });
    });
    
    console.log(`Total file fields: ${6 + optionalFields.length}`);
    
    return new Promise((resolve, reject) => {
        console.log('\nSubmitting test form to http://localhost:3000/api/submit...');
        
        const request = http.request({
            hostname: 'localhost',
            port: 3000,
            path: '/api/submit',
            method: 'POST',
            headers: formData.getHeaders()
        }, (response) => {
            let data = '';
            
            response.on('data', (chunk) => {
                data += chunk;
            });
            
            response.on('end', () => {
                try {
                    const result = JSON.parse(data);
                    
                    if (response.statusCode === 200 && result.success) {
                        console.log('\n✅ Test submission successful!');
                        console.log('Submission ID:', result.submissionId || 'N/A');
                        console.log('Files saved to:', result.files || 'uploads/');
                        console.log('\nCheck the following locations:');
                        console.log('- Form data: standalone-form/data/submissions.json');
                        console.log('- Uploaded files: standalone-form/uploads/');
                        resolve(result);
                    } else {
                        console.error('\n❌ Submission failed:');
                        console.error('Status:', response.statusCode);
                        console.error('Error:', result.error || data);
                        reject(new Error(result.error || 'Submission failed'));
                    }
                } catch (error) {
                    console.error('\n❌ Error parsing response:');
                    console.error(data);
                    reject(error);
                }
            });
        });
        
        request.on('error', (error) => {
            console.error('\n❌ Error submitting form:');
            console.error(error.message);
            reject(error);
        });
        
        formData.pipe(request);
    });
}

// Run the test
submitTestForm();

