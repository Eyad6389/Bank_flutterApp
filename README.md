# Bank Flutter App

This app is inspired by a banking app called **C-Bank**.

## 🏠 Home Screen
You start on a clean and beautiful home screen with:
- A background image
- Two buttons: **Login** and **Sign Up**
- A short description of the app

## 🔐 Authentication
- On the **Sign Up** page, you enter your user data
- After signing up, you can log in using your email and password

## 🏦 Bank Account Page
Once logged in, you are taken to the **Bank Account Page**, which includes:
- Your current **balance**
- A list of recent **transactions**
- Your **username**
- Buttons to **deposit** or **withdraw** money (the transaction is saved)
- A **scrollable news bar** powered by **NewsAPI** for financial news

## 👤 Profile Page
From the Bank Account Page, you can navigate to your **Profile Page**, where you can:
- **Edit your name**
- **Log out**
- View your **email**
- See your **two most recent transactions**

---

## 📚 References and Tools Used

- I used **Flutter documentation** to understand widgets, their attributes, and to explore new ones beyond what was covered in class.
- I used **AI tools (like ChatGPT)** to:
  - Help fix errors and crashes (especially when nothing appeared in the debug console)
  - Add helpful **comments** to explain more complex functions
- I did **not copy-paste** full solutions. I only reused a small function for a **custom TextField** from ChatGPT to save time, since I already know how to write it.

---

## 🚧 Future Plans & Limitations

- I wanted to allow users to **change their profile icon** by picking an image from their gallery.
- I used the `image_picker` package to let the user select an image.
- I tried to store the image using **Firebase Storage**, but I had issues setting it up.
- As a workaround, I used **Shared Preferences** to temporarily save the image path, but:
  - The image resets when the app is restarted.
  - I was not satisfied with this solution and plan to fix it using proper cloud storage in the future.

---

## ❗ Problems Faced & Decisions Made

- In the **home screen**, I wanted the **background image to be scrollable**, but couldn’t make it work even with help from documentation and AI. So, I made only the space below the image scrollable, which still looks good.
- In the **bank account page**, I couldn’t make just the **transactions list scrollable**. As a result, I made the **entire page scrollable**. It looks clean, and I’m satisfied with the result.
- I wanted to make the **email and password editable**, but that requires sending a **verification email**. I didn’t want to implement real email functionality since this is a student project and:
  - I’m not very experienced with **Firebase authentication**
  - I was worried someone might hack the database and access user credentials
  - So, I only allowed the **name** to be editable
- I tried to make all pages match the same exact **theme color**, but:
  - I used AI tools to generate detailed background images with specific color codes
  - Unfortunately, the images didn’t match the **exact hex colors**, so the color consistency isn’t perfect
- When I clicked the **deposit or withdraw button many times quickly**, the app **crashed**. I found (with AI help) that this happened because the transactions list was being updated before the previous one finished. To fix this:
  - I added a `bool isProcessing`
  - When a transaction starts, `isProcessing` becomes `true`
  - Once the transaction is done and added, it becomes `false`
  - If the user clicks too fast, a message shows: “**Transaction is still processing**”
- I **couldn’t run the emulator** on my laptop because it made the device too slow. Instead, I connected my **real phone using a USB cable** and ran the app on it.
  - This allowed me to test the app across **multiple phones in the house**
  - I could ensure the app **looked good on different screen sizes** and dimensions
- In the project files, you will find some **small widget files**. I made those to reduce the number of lines in the main screen files. Some widgets are small and some are larger, but this helped me **keep the main UI files clean and more organized**.

---

Created with ❤️ by **Eyad**
