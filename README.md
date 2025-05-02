# ⏳ CustomHUD

`CustomHUD` 是一個自訂的 iOS Loading View，可蓋住整個畫面，適用於處理資料等待或封鎖使用者操作期間的顯示提示。

---

## 💡 為什麼自己做？

市面上已有許多類似套件，但為了能依據專案需求更具彈性地客製化樣式、動畫、或互動行為，因此選擇自行實作 CustomHUD。

---

## 🔧 功能特點

- ✅ 蓋住整個畫面，阻止使用者誤觸
- ✅ 支援自定動畫、顏色與文字提示
- ✅ 可簡單呼叫 `CustomHUD.show()` / `CustomHUD.hide(completion: nil)`
- ✅ 容易擴充：可加入 icon、進度條、超時提示等功能

---

## 📦 使用範例

```swift
// 顯示 HUD
CustomHUD.showMessage(message: "加載中")

// 模擬延遲後隱藏
CustomHUD.showMessage(message: "加載中", delay: 3)

// 顯示成功
CustomHUD.showSuccess(completion: nil)

//顯示失敗
CustomHUD.showFail(completion: nil)

```

---

🧩 建議搭配使用：
- 任務型 API 呼叫（如登入、上傳）
- 較長時間的計算或背景處理流程

---

📌 可延伸方向：
- 加入 Lottie 動畫或模糊背景效果
