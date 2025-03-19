# Lab in Pocket - Mobile Application

## Overview
**Lab in Pocket** is a mobile application designed to assist farmers, lab technicians, and doctors in diagnosing cattle diseases based on blood smear images. The app streamlines the process from image upload to diagnosis and expert consultation.

## User Roles
1. **Farmer** - Provides their name for record-keeping.
2. **Lab Technician** - Uploads blood smear images of the farmer's cattle.
3. **Doctor** - Diagnoses the image and provides suggestions.

## Workflow
### 1. Home Page (User Selection)
- Display 'Welcome to Lab in Pocket'.
- Ask 'Are you a Doctor?' with a Yes/No option.
  - If 'Yes' → Redirect to Doctor Registration/Login Page.
  - If 'No' (Lab Technician) → Proceed to Farmer Name Entry Page.

### 2. Farmer Name Entry Page
- Input field: 'Enter Farmer Name'.
- 'Next' Button → Redirects to the Image Upload Page.

### 3. Blood Smear Image Upload Page
- Display heading: 'Upload the blood smear image of [Farmer Name]'s cattle'.
- Provide two options:
  1. Capture from Camera
  2. Upload from Gallery
- Store the uploaded image in the database.
- 'Next' Button → Redirects to the Diagnosis Page.

### 4. Diagnosis Page
- Display the Uploaded Image.
- Show Automated Diagnosis Result:
  - ✅ Infected with Babesiosis
  - ✅ Infected with Anaplasmosis
  - ❌ Not Infected
- Provide a Button: 'Suggestions from Expert'.
- If clicked, Redirect to Doctor List Page.

### 5. Doctor List Page
- Display a list of registered doctors.
- Lab Technician selects a Doctor → Image & farmer details sent to the doctor.
- Doctor receives a notification.

### 6. Doctor Login & Review Page
- Doctor logs in and sees pending cases.
- Doctor selects a case and reviews the image.
- Diagnosis options:
  1. Infected with Babesiosis
  2. Infected with Anaplasmosis
  3. Not Infected
  4. Not Clear
- Doctor provides additional suggestions (optional).
- Clicks 'Submit' → Diagnosis & suggestions are stored in the database.

### 7. Final Report Page (For Lab Technician)
- Lab Technician can view the farmer’s report with:
  - Diagnosis result from doctor.
  - Doctor's suggestions.
- Report saved in the database.

## Additional Features
### Database Structure
- Farmer Name
- Uploaded Image
- Initial AI Diagnosis
- Assigned Doctor
- Final Doctor Diagnosis
- Doctor Suggestions

### Notifications
- Doctor gets notified when a case is assigned.
- Lab Technician gets notified when a diagnosis is available.

### Admin Panel (Optional)
- Manage doctors & users.

## Technologies Used
- **Frontend:** Mobile App (Flutter/React Native)
- **Backend:** Node.js/Python
- **Database:** Firebase/MySQL
- **AI Model:** Image Processing for Diagnosis


## Contribution
1. Fork the repository.
2. Create a new branch.
3. Make your changes.
4. Submit a pull request.

## License
This project is licensed under the MIT License.

