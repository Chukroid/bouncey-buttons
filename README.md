# Bouncey Buttons
![](BounceyButtons.png)

<center>BounceyButtons is a lightweight and customizable module for animating UI button interactions in Roblox. Designed for simplicity and versatility, it adds smooth scaling animations to your buttons, enhancing the user experience across all platforms.</center>

### Bouncey Button turns your scale animated button script from this:

```lua
local TweenService = game:GetService("TweenService")
local debounce = false

button2.MouseEnter:Connect(function()
  if not debounce then
    TweenService:Create(button2.UIScale,TweenInfo.new(0.2),{Scale = 1.05}):Play()
  end
end)
button2.MouseLeave:Connect(function()
  if not debounce then
    TweenService:Create(button2.UIScale,TweenInfo.new(0.2),{Scale = 1}):Play()
  end
end)
button2.MouseButton1Click:Connect(function()
  if not debounce then
    debounce = true
    TweenService:Create(button2.UIScale,TweenInfo.new(0.1),{Scale = 0.8}):Play()
    task.spawn(function()
      task.wait(0.1)
      TweenService:Create(button2.UIScale,TweenInfo.new(0.2,Enum.EasingStyle.Back),{Scale = 1}):Play()
    end)
    print("Simple Button Clicked")
    task.wait(0.5)
    debounce = false
  end
end)
```

To this:
```lua
local RS = game:GetService("ReplicatedStorage")
local bouncifyModule = require(RS:WaitForChild("BounceyButtons"))

bouncifyModule.bouncifyBtn(button2,function()
  if not db then
    db = true
    print("Simple Button Clicked!")
    task.wait(0.5)
    db = false
  end
end)
```

## Requirements
To ensure BounceyButtons works correctly, follow these guidelines:

### Anchor Point
The GuiObject must have an AnchorPoint of ```(0.5, 0.5)```.

### UIScale Instance
A UIScale instance must exist inside the GuiObject (default name: UIScale). Alternatively, provide the UIScale instance via the ```options.uiscale``` parameter. 
Without this, scaling effects won’t be visible, but no errors will occur.

### Clicking Sound
If you want a clicking sound, you must provide the path to the sound instance for the clicking sound inside the module.




## Features

#### Custom Hover and Unhover Effects
- Add additional effects or actions when the button is hovered or unhovered using these options:
```options.hoverfunction```: A function to execute on hover.
```options.unhoverfunction```: A function to execute when hover ends.
>[!NOTE]
>If you define a hoverfunction, ensure you also provide an unhoverfunction to reset the button to its original state.

#### Custom Click Effects
- Add extra effects when the button is clicked using:
```options.clickfunction```: A function to execute during the click event (e.g., moving animations). This function won´t yeild.

#### Multiplatform Compatibility
- Works seamlessly on PC, mobile, and console platforms.

#### Clicking Sound Support
- Currently, only clicking sounds are supported.
Provide the sound instance via the ```options.clickSound``` parameter (e.g., game.Workspace.ClickSound).

#### Animating Non-Button Frames
- If your interactive element is not a TextButton or ImageButton (e.g., a Frame or ImageLabel), you can animate it by providing the invisible button (e.g., a TextButton or ImageButton) via the ```options.button parameter```.


## Available options

| option | Description |
| --- | --- |
| ```option.button``` | ```TextButton/ImageButton``` that the MouseButton1Click/Activated event is connected to |
| ```option.uiscale``` | ```UIScale``` object inside the button |
| ```option.hoverfunction``` | ```function``` that will run when the mouse hovers over the button |
| ```option.unhoverfunction``` | ```function``` that will run when the mouse leaves the button |
| ```option.clickfunction``` | ```function``` that will run when the button is clicked, use only for animating since it does not yeild |
| ```option.maxsize``` | ```Number```. The maximum size that the UIScale object will scale to |
| ```option.minsize``` | ```Number```. The minimum size that the uiscale object will scale to |
| ```option.soundless``` | ```Boolean```. Indicates that no sounds should be played |


## Example Usage

#### Basic Usage
```lua
local bouncifyModule = require(game:GetService("ReplicatedStorage"):WaitForChild("BounceyButtons"))
local button1 = script.Parent

bouncifyModule.bouncifyBtn(button1,function()
  print("Simple Button Clicked!")
end)
```

#### Adding Custom Hover and Click Effects
```lua
local bouncifyModule = require(game:GetService("ReplicatedStorage"):WaitForChild("BounceyButtons"))
local button1 = script.Parent

bouncifyModule.bouncifyBtn(button1,function()
  print("Simple Button Clicked!")
end,{
  hoverfunction = function()
    button1.BackgroundColor3 = Color3.new(1, 0, 0) -- Change to red on hover
  end,
  unhoverfunction = function()
    button1.BackgroundColor3 = Color3.new(1, 1, 1) -- Reset to white on unhover
  end,
  clickfunction = function()
    button1.TextButton.Position = UDim2.fromScale(0.5,0.5)
    task.wait(0.2)
    button1.TextButton.Position = UDim2.fromScale(0.52,0.4)
  end,
})
```

#### Animating Non-Button Frames
```lua
local bouncifyModule = require(game:GetService("ReplicatedStorage"):WaitForChild("BounceyButtons"))
local button1 = script.Parent

bouncifyModule.bouncifyBtn(button1,function()
  print("Simple Button Clicked!")
end,{
  button = button1.TextButton
})
```

## Why Use the BounceyButtons Module
- **Write Less Code**: Simplifies button animation setup, letting you focus on your game logic.
- **Focus on Functionality**: Concentrate on what your button should do without worrying about animation details.
- **Lightweight and Flexible**: Optimized for performance and easy to modify to suit your needs since it is open-source.

#### This is my first ever public release module! 🎉 If you have any suggestions to make it better or improvements you'd like to see, please feel free to let me know. I'm also open to pull requests, so don’t hesitate to contribute! 😊
