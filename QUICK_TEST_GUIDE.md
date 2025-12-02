# 🧪 Feed & Post MVP - Quick Test Guide

## Quick Start

### 1️⃣ Launch the App
```bash
cd c:\Users\DELL\ate_app
flutter run
```

### 2️⃣ Navigate to Feed
- Look for "Feed" or home section
- You should see an empty feed (first time)

### 3️⃣ Create Your First Post

**Step 1: Pick Images**
- Click FAB (+ button) or "Create Post"
- Select "Pick images" → Choose 1-3 photos
- Click "Next"

**Step 2: Fill Details**
- **Caption** (required): "Delicious biryani at my favorite place! 🍛"
- **Restaurant** (required): "Taj Mahal Restaurant"
- **Dish Name** (optional): "Hyderabadi Biryani"
- **Rating** (required): Click 5 stars
- Click "Publish"

✅ **Expected**: Post appears at top of feed with image carousel

### 4️⃣ Test Like Functionality

**Action**: Click the heart icon on your post
- ❤️ Heart turns red
- Number increases by 1
- **Close and reopen app** → Heart stays red ✅

### 5️⃣ Test Save Functionality

**Action**: Click the bookmark icon on your post
- 📌 Bookmark fills with color
- **Close and reopen app** → Bookmark stays filled ✅

### 6️⃣ Create More Posts

Repeat steps 3-5 to create 15+ posts to test:
- Scroll behavior
- Load more functionality
- Feed pagination

### 7️⃣ Test Pull-to-Refresh

**Action**: Swipe down from top of feed
- Refresh spinner appears
- Feed reloads
- ✅ Works

### 8️⃣ Test Localization

**Change Language** (in settings if available):
- Switch to "Français" or "العربية"
- Check all labels change
- Verify consistency

---

## ✅ Verification Checklist

- [ ] App launches without errors
- [ ] Can create post with 1-3 images
- [ ] Images are displayed in carousel
- [ ] Post appears in feed
- [ ] Like button works and persists
- [ ] Save button works and persists
- [ ] Pull-to-refresh works
- [ ] Load more works with 15+ posts
- [ ] App restart preserves post data
- [ ] Localization works (if tested)

---

## 🐛 If Something Breaks

### App won't start?
```bash
flutter clean
flutter pub get
flutter run
```

### Post not appearing in feed?
- Check database: Look for `app.db` in device storage
- Check logs: `flutter run -v`

### Images not showing?
- Verify image file paths are saved
- Check app has file access permission

### Database errors?
- Uninstall app completely
- Clear app data
- Reinstall

---

## 📊 Performance Metrics to Watch

- **Cold Start**: Should be < 5 seconds
- **Feed Load**: Should be < 1 second (10 posts)
- **Image Scroll**: Should be smooth (60 FPS)
- **Like/Save**: Should respond < 100ms

---

## 🎯 Success Criteria

### MVP is working if:
1. ✅ Can create posts with images
2. ✅ Posts persist after app restart
3. ✅ Likes persist after app restart
4. ✅ Saves persist after app restart
5. ✅ Feed loads smoothly
6. ✅ Load more works with pagination
7. ✅ Zero app crashes

---

## 📱 Device Requirements

**Minimum:**
- Android 7.0 / iOS 11.0
- 100 MB free storage
- 2 GB RAM

**Recommended:**
- Android 11+ / iOS 14+
- 500 MB free storage
- 4+ GB RAM

---

## 🚀 Test Execution Time

| Task | Duration |
|------|----------|
| App Launch | 30-60 sec |
| Create Post | 10-15 sec |
| Like/Save | < 1 sec |
| Scroll Feed | < 5 sec |
| Language Change | < 2 sec |
| **Total** | **~5-10 min** |

---

## 💡 Pro Tips

1. **Use Device Logs**: `flutter logs` to see errors
2. **Speed Up Build**: Use `--no-fast-start` flag
3. **Test on Real Device**: Emulator may behave differently
4. **Check Storage**: Use file explorer to verify images are saved
5. **Monitor Memory**: Use Android Profiler for performance

---

## 📞 Support

If issues arise:
1. Check `FEED_POST_MVP_TEST_REPORT.md` for detailed architecture
2. Review commit messages for changes made
3. Check flutter logs: `flutter run -v`
4. Verify pubspec.yaml dependencies

---

**Happy Testing! 🎉**

*Last Updated: December 2, 2025*
