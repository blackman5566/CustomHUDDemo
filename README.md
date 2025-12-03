# ⏳ CustomHUD (UIKit Version)

`CustomHUD` is a lightweight, fully customizable loading and status indicator for iOS.  
It covers the entire screen and provides a clean way to block user interaction during long-running tasks, API requests, form submissions, or any asynchronous operations.

Designed originally for UIKit-based apps, `CustomHUD` offers simple APIs, flexible styling, and support for custom animations or icons.

## 💡 Why build a custom HUD?

While many HUD libraries exist (SVProgressHUD, MBProgressHUD, Toasts, etc.),  
**this implementation focuses on:**

- Full control over animation timing  
- Easy styling and theme customization  
- Precise control over user interaction  
- Minimal dependencies  
- Simple, predictable API surface  

This HUD is also ideal when your project requires a **consistent design system** or when you want to avoid heavy 3rd-party dependencies.

## 🔧 Features

- ✅ Full-screen overlay to prevent accidental touches  
- ✅ Customizable colors, opacity, and animations  
- ✅ Simple global API: `CustomHUD.show()` / `CustomHUD.hide()`  
- ✅ Supports loading, success, failure, and message modes  
- ✅ Designed for extendability (icons, progress, blur effects, etc.)  
- ✅ Works in any UIKit environment (`UIWindow`, view controllers, modals, navigation stack)

## 📦 Usage Examples

```swift
// Show loading HUD with text
CustomHUD.showMessage(message: "Loading...")

// Show loading and automatically hide after 3 seconds
CustomHUD.showMessage(message: "Loading...", delay: 3)

// Show success icon with fade-out animation
CustomHUD.showSuccess(completion: nil)

// Show failure icon
CustomHUD.showFail(completion: nil)
```

## 📘 When to use CustomHUD?

This HUD is useful in situations such as:

- API calls (login, submit forms, update profile)
- File uploads, downloads, or sync tasks
- Long-running calculations
- Payment or checkout flows
- Blocking actions until validation completes

Essentially, **any moment you want a clean, app-wide “please wait” experience.**

## 🧩 Extendability Ideas

You can easily extend `CustomHUD` to support:

- Lottie animations  
- Blur or vibrancy background  
- Dynamic color themes (light/dark)  
- Progress indicators (circular or linear)  
- Custom icons (success, error, warning, info)  
- Queued or chained HUD sequences  

The implementation is designed to stay modular so you can plug in your own animation layers.

## ✔️ Summary

`CustomHUD` is built with simplicity and flexibility in mind.  
It avoids heavy dependencies while giving you full control over the user experience.  
Perfect for UIKit projects that need a reliable, customizable loading indicator.
