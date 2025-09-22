# Phase 1 Testing Guide: Number Capture

## 🎉 Phase 1 Implementation Complete!

**What was implemented:**
- Enabled number digit capture (1-9) in VimMode
- Numbers appear in status indicator as they're typed
- Proper number reset on escape and mode transitions
- Multi-digit number support (23, 456, etc.)

## How to Test Phase 1

### Prerequisites
1. **Reload Hammerspoon** to pick up the changes:
   - Press `Cmd+Shift+R` if you have reload hotkey configured
   - OR restart Hammerspoon.app completely
   - OR run `hs.reload()` in Hammerspoon console

### Test Steps

#### Test 1: Basic Number Display
1. Open any text application (TextEdit, Notes, etc.)
2. Enter VimMode normal mode (use your configured key, e.g., `jk` or `Ctrl+;`)
3. You should see the "NORMAL" status indicator
4. Type `2` - you should see `NORMAL [2]` in the status indicator
5. Type `3` - you should see `NORMAL [23]` in the status indicator
6. Press `Escape` - the `[23]` should disappear, showing just `NORMAL`

**✅ Success criteria:** Numbers appear in brackets in the status indicator

#### Test 2: Multi-digit Numbers
1. In normal mode, type `456`
2. You should see `NORMAL [456]` in the status indicator
3. Try typing `1234567890` (though 0 might behave differently)
4. Press `Escape` to clear

**✅ Success criteria:** Multi-digit numbers accumulate correctly

#### Test 3: Number Reset Behavior
1. Type `25`
2. Press `Escape` - numbers should clear
3. Type `33`
4. Press `i` to enter insert mode - numbers should clear and status should disappear
5. Press your enter-normal-mode key again
6. Type `44` - should start fresh (not continue from previous numbers)

**✅ Success criteria:** Numbers reset properly on mode changes

#### Test 4: Operator Context
1. In normal mode, type `3`
2. Press `d` (delete operator) - you should see `NORMAL [3d]`
3. Type `2` - you should see `NORMAL [3d2]`
4. Press `Escape` - should clear everything and return to normal mode

**✅ Success criteria:** Numbers work in operator-pending mode

## What to Expect

### ✅ Working in Phase 1:
- Numbers 1-9 display in status indicator
- Multi-digit number accumulation (23, 456, etc.)
- Number clearing on Escape
- Number clearing on mode transitions
- Numbers work in both normal and operator-pending contexts

### ❌ NOT Working Yet (Future Phases):
- **Numbers don't actually multiply motions yet** (that's Phase 2)
- `5j` will show `[5j]` but only move 1 line down
- `3dw` will show `[3dw]` but only delete 1 word
- This is expected! Phase 1 is just about **capturing** numbers

## Troubleshooting

### Issue: Numbers don't appear in status indicator
**Solutions:**
1. Make sure you reloaded Hammerspoon after the changes
2. Check that `shouldShowAlertInNormalMode` is not disabled in your config
3. Try in a different app (some apps have accessibility issues)

### Issue: Status indicator not visible
**Solutions:**
1. Check your VimMode configuration for `vim:shouldShowAlertInNormalMode(false)`
2. Try moving to a different screen position
3. Test in TextEdit.app which has good accessibility support

### Issue: Numbers don't clear on Escape
**Solutions:**
1. This indicates a binding issue - check Hammerspoon console for errors
2. Try restarting Hammerspoon completely

## Next Phase Preview

**Phase 2** will make the captured numbers actually work:
- `5j` will move down 5 lines
- `3w` will move forward 3 words
- `10h` will move left 10 characters

But first, **please test Phase 1 thoroughly** and confirm that number capture is working perfectly before we proceed!

## Report Results

Test each scenario above and report:
1. ✅ What works as expected
2. ❌ What doesn't work or behaves unexpectedly  
3. 🤔 Any weird edge cases you discover

Once Phase 1 is confirmed working, we'll proceed to Phase 2: Motion Multiplication!