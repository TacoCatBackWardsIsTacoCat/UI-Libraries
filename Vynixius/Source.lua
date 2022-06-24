-- Library

local Library = {
	Theme = {
		Accent = Color3.fromRGB(0, 255, 0),
		TopbarColor = Color3.fromRGB(20, 20, 20),
		SidebarColor = Color3.fromRGB(15, 15, 15),
		BackgroundColor = Color3.fromRGB(10, 10, 10),
		SectionColor = Color3.fromRGB(20, 20, 20),
		TextColor = Color3.fromRGB(255, 255, 255),
		Objects = {},
	},
	Notif = { Active = {}, Queue = {}, IsBusy = false },
	Key = Enum.KeyCode.RightControl,
}

-- Services

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")
local TS = game:GetService("TweenService")
local TXS = game:GetService("TextService")
local CG = game:GetService("CoreGui")

-- Variables

local Utils = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Utils.lua"))()
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local Storage = { Connections = {}, Tween = { Cosmetic = {} } }

local ScreenGui = Utils.Create("ScreenGui", {
	Name = "Vynixius UI Library",
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

ScreenGui.Parent = game:GetService("CoreGui")

-- Functions

local function tween(...)
	local args = {...}

	if typeof(args[2]) ~= "string" then
		table.insert(args, 2, "")
	end

	local tween = TS:Create(args[1], TweenInfo.new(args[3], Enum.EasingStyle.Quint), args[4])

	if args[2] == "Cosmetic" then
		Storage.Tween.Cosmetic[#Storage.Tween.Cosmetic + 1] = tween

		task.spawn(function()
			task.wait(args[3])
			
			local tweenIndex = table.find(Storage.Tween.Cosmetic, tween)
			if tweenIndex ~= nil then
				table.remove(Storage.Tween.Cosmetic, tweenIndex)
			end
		end)
	end

	tween:Play()
end

function Library:Notify(options, callback)
	if Library.Notif.IsBusy == true then
		Library.Notif.Queue[#Library.Notif.Queue + 1] = { options, callback }
		return
	end	
	
	Library.Notif.IsBusy = true
	
	local Notification = {
		Type = "Notification",
		Selection = nil,
		Callback = callback,
	}
	
	Notification.Frame = Utils.Create("Frame", {
		Name = "Notification",
		BackgroundTransparency = 1,
		ClipsDescendants = true,
		Position = UDim2.new(0, 10, 1, -66),
		Size = UDim2.new(0, 320, 0, 56),
		
		Utils.Create("Frame", {
			Name = "Topbar",
			BackgroundColor3 = Library.Theme.TopbarColor,
			Size = UDim2.new(1, 0, 0, 28),

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.TopbarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0.5, 0),
			}),
			
			Utils.Create("TextLabel", {
				Name = "Title",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 7, 0.5, -8),
				Size = UDim2.new(1, -54, 0, 16),
				Font = Enum.Font.SourceSans,
				Text = options.title or "Notification",
				TextColor3 = Library.Theme.TextColor,
				TextSize = 16,
				TextXAlignment = Enum.TextXAlignment.Left,
			}),
			
			Utils.Create("ImageButton", {
				Name = "Yes",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -24, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "http://www.roblox.com/asset/?id=7919581359",
				ImageColor3 = Library.Theme.TextColor,
			}),
			
			Utils.Create("ImageButton", {
				Name = "No",
				AnchorPoint = Vector2.new(1, 0),
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -2, 0.5, -10),
				Size = UDim2.new(0, 20, 0, 20),
				Image = "http://www.roblox.com/asset/?id=7919583990",
				ImageColor3 = Library.Theme.TextColor,
			}),
		}, UDim.new(0,5)),
		
		Utils.Create("Frame", {
			Name = "Background",
			BackgroundColor3 = Library.Theme.BackgroundColor,
			Position = UDim2.new(0, 0, 0, 28),
			Size = UDim2.new(1, 0, 1, -28),
			
			Utils.Create("TextLabel", {
				Name = "Description",
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 7, 0, 7),
				Size = UDim2.new(1, -14, 1, -14),
				Font = Enum.Font.SourceSans,
				Text = options.text,
				TextColor3 = Library.Theme.TextColor,
				TextSize = 14,
				TextWrapped = true,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
			}),
			
			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 5),
			}),
		}, UDim.new(0, 5)),
	})

	if options.color ~= nil then
		local indicator = Utils.Create("Frame", {
			Name = "Indicator",
			BackgroundColor3 = Color3.fromRGB(25, 230, 25),
			Size = UDim2.new(0, 4, 1, 0),
			
			Utils.Create("Frame", {
				BackgroundColor3 = Color3.fromRGB(25, 230, 25),
				BorderSizePixel = 0,
				Position = UDim2.new(0.5, 0, 0, 0),
				Size = UDim2.new(0.5, 0, 1, 0),
			}, UDim.new(0, 5)),
		})
		
		Notification.Frame.Topbar.Title.Position = UDim2.new(0, 11, 0.5, -8)
		Notification.Frame.Topbar.Title.Size = UDim2.new(1, -60, 0, 16)
		Notification.Frame.Background.Description.Position = UDim2.new(0, 11, 0, 7)
		Notification.Frame.Background.Description.Size = UDim2.new(1, -18, 1, -14)
	end
	
	-- Functions
	
	function Notification:GetHeight()
		return 42 + math.round(TXS:GetTextSize(Notification.Frame.Background.Description.Text, 14, Enum.Font.SourceSans, Vector2.new(9e9, 5 * 14)).Y + 0.5)
	end
	
	function Notification:Select(bool)
		task.spawn(Notification.Callback, bool)
		
		tween(Notification.Frame.Topbar[bool and "Yes" or "No"], 0.1, { ImageColor3 = bool and Color3.fromRGB(75, 255, 75) or Color3.fromRGB(255, 75, 75) })
		tween(Notification.Frame, 1, { Position = UDim2.new(0, -320, 0, Notification.Frame.AbsolutePosition.Y) })
		
		local notifIndex = table.find(Library.Notif.Active, Notification)
		if notifIndex then
			table.remove(Library.Notif.Active, notifIndex)
		end
	end
	
	-- Scripts
	
	Library.Notif.Active[#Library.Notif.Active + 1] = Notification
	Storage.Connections[Notification] = {}
	Notification.Frame.Size = UDim2.new(0, 320, 0, Notification:GetHeight())
	Notification.Frame.Position = UDim2.new(0, -320, 1, -Notification:GetHeight() - 10)
	Notification.Frame.Parent = ScreenGui
	
	if #Library.Notif.Active > 5 then
		Library.Notif.Active[1]:Select(false)
	end
	
	for i, v in next, Library.Notif.Active do
		if v ~= Notification then
			tween(v.Frame, 0.5, { Position = v.Frame.Position - UDim2.new(0, 0, 0, Notification:GetHeight() + 10) })
		end
	end
	
	tween(Notification.Frame, 0.5, { Position = UDim2.new(0, 10, 1, -Notification:GetHeight() - 10) })
	
	task.spawn(function()
		task.wait(0.5)

		Storage.Connections[Notification].Yes = Notification.Frame.Topbar.Yes.Activated:Connect(function()
			Notification:Select(true)
		end)

		Storage.Connections[Notification].No = Notification.Frame.Topbar.No.Activated:Connect(function()
			Notification:Select(false)
		end)
		
		Library.Notif.IsBusy = false
		
		if #Library.Notif.Queue > 0 then
			local notif = Library.Notif.Queue[1]
			table.remove(Library.Notif.Queue, 1)
			
			Library:Notify(notif[1], notif[2])
		end
	end)
	
	task.spawn(function()
		task.wait(10)
		
		if Notification.Selection == nil then
			Notification:Select(false)
		end
	end)
	
	return Notification
end

function Library:AddWindow(options)
	local Window = {
		Name = options.title[1].. " ".. options.title[2],
		Type = "Window",
		Tabs = {},
		Sidebar = { List = {}, Toggled = false },
		Toggled = options.default or true,
	}

	-- Custom theme setup

	if options.theme ~= nil then
		for i, v in next, options.theme do
			if typeof(Library.Theme[i]) == "Color3" then
				Library.Theme[i] = v
			end
		end
	end

	-- Window construction

	Window.Frame = Utils.Create("Frame", {
		Name = "Window",
		BackgroundTransparency = 1,
		Size = UDim2.new(0, 460, 0, 497),
		Position = UDim2.new(1, -490, 1, -527),

		Utils.Create("Frame", {
			Name = "Topbar",
			BackgroundColor3 = Library.Theme.TopbarColor,
			Size = UDim2.new(1, 0, 0, 40),

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.TopbarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(0, 0, 0.5, 0),
				Size = UDim2.new(1, 0, 0.5, 0),
			}),

			Utils.Create("TextLabel", {
				Name = "Title",
				AnchorPoint = Vector2.new(0.5, 0.5),
				BackgroundTransparency = 1,
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Size = UDim2.new(1, -20, 0, 22),
				Font = Enum.Font.SourceSans,
				Text = string.format("%s - <font color='%s'>%s</font>", options.title[1], Utils.Colors.ToFormat(Library.Theme.Accent), options.title[2]),
				RichText = true,
				TextColor3 = Library.Theme.TextColor,
				TextSize = 22,
				TextWrapped = true,
			}),
		}, UDim.new(0, 5)),

		Utils.Create("Frame", {
			Name = "Background",
			BackgroundColor3 = Library.Theme.BackgroundColor,
			Position = UDim2.new(0, 30, 0, 40),
			Size = UDim2.new(1, -30, 1, -40),

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 5),
			}),

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Size = UDim2.new(0, 5, 1, 0),
			}),

			Utils.Create("Frame", {
				Name = "Tabs",
				BackgroundColor3 = Utils.Colors.Add(Library.Theme.BackgroundColor, Color3.fromRGB(15, 15, 15)),
				Position = UDim2.new(0, 3, 0, 3),
				Size = UDim2.new(1, -6, 1, -6),

				Utils.Create("Frame", {
					Name = "Holder",
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.BackgroundColor, Color3.fromRGB(5, 5, 5)),
					Position = UDim2.new(0, 1, 0, 1),
					Size = UDim2.new(1, -2, 1, -2),
				}, UDim.new(0, 5)),
			}, UDim.new(0, 5)),
		}, UDim.new(0, 5)),

		Utils.Create("Frame", {
			Name = "Sidebar",
			BackgroundColor3 = Library.Theme.SidebarColor,
			Position = UDim2.new(0, 0, 0, 40),
			Size = UDim2.new(0, 30, 1, -40),
			ZIndex = 2,

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.SidebarColor,
				BorderSizePixel = 0,
				Size = UDim2.new(1, 0, 0, 5),
			}),

			Utils.Create("Frame", {
				Name = "Filling",
				BackgroundColor3 = Library.Theme.SidebarColor,
				BorderSizePixel = 0,
				Position = UDim2.new(1, -5, 0, 0),
				Size = UDim2.new(0, 5, 1, 0),
			}),

			Utils.Create("Frame", {
				Name = "Border",
				BackgroundColor3 = Library.Theme.BackgroundColor,
				BorderSizePixel = 0,
				Position = UDim2.new(1, 0, 0, 0),
				Selectable = true,
				Size = UDim2.new(0, 5, 1, 0),
				ZIndex = 2,
			}),

			Utils.Create("Frame", {
				Name = "Line",
				BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(10, 10, 10)),
				BorderSizePixel = 0,
				Position = UDim2.new(0, 5, 0, 29),
				Size = UDim2.new(1, -10, 0, 2),
			}),

			Utils.Create("ScrollingFrame", {
				Name = "List",
				Active = true,
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				ClipsDescendants = true,
				Position = UDim2.new(0, 5, 0, 35),
				Size = UDim2.new(1, -10, 1, -40),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				ScrollBarThickness = 5,

				Utils.Create("UIListLayout", {
					SortOrder = Enum.SortOrder.LayoutOrder,
					Padding = UDim.new(0, 5),
				}),
			}),

			Utils.Create("TextLabel", {
				Name = "Indicator",
				BackgroundTransparency = 1,
				Position = UDim2.new(1, -30, 0, 0),
				Size = UDim2.new(0, 30, 0, 30),
				Font = Enum.Font.SourceSansBold,
				Text = "+",
				TextColor3 = Library.Theme.TextColor,
				TextSize = 20,
			}),
		}, UDim.new(0, 5))
	})

	-- Functions

	function Window:Toggle(bool)
		self.Toggled = bool
		self.Gui.Enabled = bool
	end

	local function setAccent(accent)
		Library.Theme.Accent = accent
		Window.Frame.Topbar.Title.Text = string.format("%s - <font color='%s'>%s</font>", options.title[1], Utils.Colors.ToFormat(accent), options.title[2])

		for _, tab in next, Window.Tabs do
			for _, section in next, tab.Sections do
				for _, item in next, section.List do

					for _, tween in next, Storage.Tween.Cosmetic do
						tween:Cancel()
					end

					if tab.Flags[item.Flag] == true or item.Rainbow == true then
						for _, v in next, item.Frame:GetDescendants() do
							if v.Name == "Overlay" then
								v.BackgroundColor3 = Utils.Colors.Add(accent, Color3.fromRGB(50, 50, 50))
							end
						end
					end

					if item.Type == "Slider" then
						item.Frame.Holder.Slider.Bar.Fill.BackgroundColor3 = Utils.Colors.Sub(accent, Color3.fromRGB(50, 50, 50))
						item.Frame.Holder.Slider.Point.BackgroundColor3 = accent
					end

				end
			end
		end
	end

	function Window:SetAccent(accent)
		if typeof(accent) == "string" and string.lower(accent) == "rainbow" then
			if Storage.Connections.WindowRainbow ~= nil then
				Storage.Connections.WindowRainbow:Disconnect()
			end
			
			Storage.Connections.WindowRainbow = RS.Heartbeat:Connect(function()
				setAccent(Color3.fromHSV(tick() % 5 / 5, 1, 1))
			end)
		else
			setAccent(accent)
		end
	end

	local function toggleSidebar(bool)
		Window.Sidebar.Toggled = bool

		task.spawn(function()
			task.wait(bool and 0 or 0.5)
			Window.Sidebar.Frame.Border.Visible = bool
		end)

		tween(Window.Sidebar.Frame, 0.5, { Size = UDim2.new(0, bool and 130 or 30, 1, -40) })
		tween(Window.Sidebar.Frame.Indicator, 0.5, { Rotation = bool and 45 or 0 })

		for i, v in next, Window.Sidebar.List do
			tween(v.Frame.Button, 0.5, { BackgroundTransparency = bool and 0 or 1 })
			tween(v.Frame, 0.5, { BackgroundTransparency = bool and 0 or 1 })
		end
	end

	-- Scripts
	
	Library.Key = options.key or Library.Key
	Storage.Connections[Window] = {}
	Utils.MakeDraggable(Window.Frame, Window.Frame.Topbar, 0.1)
	Window.Sidebar.Frame = Window.Frame.Sidebar
	Window.Frame.Parent = ScreenGui

	UIS.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed == false and input.KeyCode == Library.Key then
			Window:Toggle(not Window.Toggled)
		end
	end)

	Window.Sidebar.Frame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Y - Window.Sidebar.Frame.AbsolutePosition.Y <= 25 then
			toggleSidebar(not Window.Sidebar.Toggled)
		end
	end)

	-- Tab

	function Window:AddTab(name, options)
		local Tab = {
			Name = name,
			Type = "Tab",
			Sections = {},
			Flags = {},
			Button = {
				Name = name,
				Selected = options.default == true,
			},
		}

		Tab.Frame = Utils.Create("ScrollingFrame", {
			Name = "Tab",
			Active = true,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 5, 0, 5),
			Size = UDim2.new(1, -10, 1, -10),
			ScrollBarImageColor3 = Utils.Colors.Add(Library.Theme.BackgroundColor, Color3.fromRGB(15, 15, 15)),
			ScrollBarThickness = 5,
			Visible = false,

			Utils.Create("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				Padding = UDim.new(0, 5),
			}),
		})

		Tab.Button.Frame = Utils.Create("Frame", {
			Name = name,
			BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)),
			BackgroundTransparency = 1,
			Size = UDim2.new(0, 120, 0, 32),

			Utils.Create("TextButton", {
				Name = "Button",
				AutoButtonColor = false,
				BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)),
				BackgroundTransparency = 1,
				Position = UDim2.new(0, 1, 0, 1),
				Size = UDim2.new(1, -2, 1, -2),
				Font = Enum.Font.SourceSans,
				Text = name,
				TextColor3 = Library.Theme.TextColor,
				TextSize = 14,
				TextWrapped = true,
			}, UDim.new(0, 5)),
		}, UDim.new(0, 5))

		-- Functions

		function Tab:Show()
			for i, v in next, Window.Tabs do
				local bool = v == self

				v.Frame.Visible = bool
				v.Button.Selected = bool

				tween(v.Button.Frame.Button, 0.1, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(35, 35, 35)) or Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)) })
				tween(v.Button.Frame, 0.1, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(45, 45, 45)) or Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
			end

			toggleSidebar(false)
		end

		function Tab:Hide()
			self.Frame.Visible = false
		end

		function Tab:GetHeight()
			local height = 0

			for i, v in next, self.Sections do
				height = height + v:GetHeight() + (i < #self.Sections and 5 or 0)
			end

			return height
		end

		function Tab:UpdateHeight()
			Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight())
		end

		-- Scripts

		Window.Tabs[#Window.Tabs + 1] = Tab
		Window.Sidebar.List[#Window.Sidebar.List + 1] = Tab.Button
		Tab.Frame.Parent = Window.Frame.Background.Tabs.Holder
		Tab.Frame.CanvasSize = UDim2.new(0, 0, 0, Tab.Frame.AbsoluteSize.Y + 1)
		Tab.Button.Frame.Parent = Window.Frame.Sidebar.List

		Tab.Frame.ChildAdded:Connect(function(c)
			if c.ClassName == "Frame" then
				Tab:UpdateHeight()
			end
		end)

		Tab.Frame.ChildRemoved:Connect(function(c)
			if c.ClassName == "Frame" then
				Tab:UpdateHeight()
			end
		end)

		Tab.Button.Frame.Button.MouseEnter:Connect(function()
			if Tab.Button.Selected == false then
				tween(Tab.Button.Frame.Button, 0.1, { BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
				tween(Tab.Button.Frame, 0.1, { BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(25, 25, 25)) })
			end
		end)

		Tab.Button.Frame.Button.MouseLeave:Connect(function()
			if Tab.Button.Selected == false then
				tween(Tab.Button.Frame.Button, 0.1, { BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(5, 5, 5)) })
				tween(Tab.Button.Frame, 0.1, { BackgroundColor3 = Utils.Colors.Add(Library.Theme.SidebarColor, Color3.fromRGB(15, 15, 15)) })
			end
		end)

		Tab.Button.Frame.Button.Activated:Connect(function()
			if Tab.Button.Selected == false then
				Tab:Show()
			end
		end)

		if options.default == true then
			Tab:Show()
		end

		-- Section

		function Tab:AddSection(name, options)
			local Section = {
				Name = name,
				Type = "Section",
				Toggled = options.default == true,
				List = {},
			}

			Section.Frame = Utils.Create("Frame", {
				Name = "Section",
				BackgroundColor3 = Library.Theme.SectionColor,
				ClipsDescendants = true,
				Size = UDim2.new(1, -10, 0, 40),

				Utils.Create("Frame", {
					Name = "Line",
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 5, 0, 30),
					Size = UDim2.new(1, -10, 0, 2),
				}),

				Utils.Create("TextLabel", {
					Name = "Header",
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 5, 0, 8),
					Size = UDim2.new(1, -40, 0, 14),
					Font = Enum.Font.SourceSans,
					Text = name,
					TextColor3 = Library.Theme.TextColor,
					TextSize = 14,
					TextWrapped = true,
					TextXAlignment = Enum.TextXAlignment.Left,
				}),

				Utils.Create("Frame", {
					Name = "List",
					BackgroundTransparency = 1,
					ClipsDescendants = true,
					Position = UDim2.new(0, 5, 0, 40),
					Size = UDim2.new(1, -10, 1, -40),

					Utils.Create("UIListLayout", {
						SortOrder = Enum.SortOrder.LayoutOrder,
						HorizontalAlignment = Enum.HorizontalAlignment.Center,
						Padding = UDim.new(0, 5),
					}),

					Utils.Create("UIPadding", {
						PaddingBottom = UDim.new(0, 1),
						PaddingLeft = UDim.new(0, 1),
						PaddingRight = UDim.new(0, 1),
						PaddingTop = UDim.new(0, 1),
					}),
				}),

				Utils.Create("TextLabel", {
					Name = "Indicator",
					BackgroundTransparency = 1,
					Position = UDim2.new(1, -30, 0, 0),
					Size = UDim2.new(0, 30, 0, 30),
					Font = Enum.Font.SourceSansBold,
					Text = "+",
					TextColor3 = Library.Theme.TextColor,
					TextSize = 20,
				})
			}, UDim.new(0, 5))

			-- Functions

			local function toggleSection(bool)
				Section.Toggled = bool

				tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
				tween(Section.Frame.Indicator, 0.5, { Rotation = bool and 45 or 0 })

				tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
			end

			function Section:GetHeight()
				local height = 40

				if Section.Toggled == true then
					for i, v in next, self.List do
						height = height + (v.GetHeight ~= nil and v:GetHeight() or v.Frame.AbsoluteSize.Y) + 5
					end
				end

				return height
			end

			function Section:UpdateHeight()
				if Section.Toggled == true then
					Section.Frame.Size = UDim2.new(1, -10, 0, Section:GetHeight())
					Section.Frame.Indicator.Rotation = 45
					
					Tab:UpdateHeight()
				end
			end

			-- Scripts

			Tab.Sections[#Tab.Sections + 1] = Section
			Section.Frame.Parent = Tab.Frame

			Section.Frame.List.ChildAdded:Connect(function(c)
				if c.ClassName == "Frame" then
					Section:UpdateHeight()
				end
			end)

			Section.Frame.InputBegan:Connect(function(input)
				if input.UserInputType == Enum.UserInputType.MouseButton1 and #Section.List > 0 and Window.Sidebar.Frame.AbsoluteSize.X <= 35 and Mouse.Y - Section.Frame.AbsolutePosition.Y <= 30 then
					toggleSection(not Section.Toggled)
				end
			end)

			-- Button

			function Section:AddButton(name, callback)
				local Button = {
					Name = name,
					Type = "Button",
					Callback = callback,
				}

				Button.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Size = UDim2.new(1, -2, 1, -2),
						Position = UDim2.new(0, 1, 0, 1),

						Utils.Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(1, -4, 1, -4),
							AutoButtonColor = false,
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				local function buttonVisual()
					task.spawn(function()
						local Visual = Utils.Create("Frame", {
							Name = "Visual",
							AnchorPoint = Vector2.new(0.5, 0.5),
							BackgroundColor3 = Color3.fromRGB(255, 255, 255),
							BackgroundTransparency = 0.9,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0, 0, 1, 0),
						}, UDim.new(0, 5))

						Visual.Parent = Button.Frame.Holder.Button
						tween(Visual, 0.5, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1 })
						task.wait(0.5)
						Visual:Destroy()
					end)
				end

				-- Scripts

				Section.List[#Section.List + 1] = Button
				Button.Frame.Parent = Section.Frame.List

				Button.Frame.Holder.Button.MouseButton1Down:Connect(function()
					Button.Frame.Holder.Button.TextSize = 12
				end)

				Button.Frame.Holder.Button.MouseButton1Up:Connect(function()
					Button.Frame.Holder.Button.TextSize = 14
					buttonVisual()

					task.spawn(Button.Callback)
				end)

				Button.Frame.Holder.Button.MouseLeave:Connect(function()
					Button.Frame.Holder.Button.TextSize = 14
				end)

				return Button
			end

			-- Toggle

			function Section:AddToggle(name, options, callback)
				local Toggle = {
					Name = name,
					Type = "Toggle",
					Flag = options.flag or name,
					Callback = callback,
				}

				Toggle.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -50, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = "Toggle",
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						Utils.Create("Frame", {
							Name = "Indicator",
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							Position = UDim2.new(1, -42, 0, 2),
							Size = UDim2.new(0, 40, 0, 26),

							Utils.Create("ImageLabel", {
								Name = "Overlay",
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
								Position = UDim2.new(0, 2, 0, 2),
								Size = UDim2.new(0, 22, 0, 22),
								Image = "http://www.roblox.com/asset/?id=7827504335",
								ImageTransparency = 1,
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5))
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				function Toggle:Set(bool, instant)
					Tab.Flags[Toggle.Flag] = bool
					task.spawn(Toggle.Callback, bool)

					tween(Toggle.Frame.Holder.Indicator.Overlay, 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
					tween(Toggle.Frame.Holder.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.Accent, Color3.fromRGB(50, 50, 50)) or Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })
				end

				-- Scripts

				Section.List[#Section.List + 1] = Toggle
				Tab.Flags[Toggle.Flag] = options.default == true
				Toggle.Frame.Parent = Section.Frame.List

				Toggle.Frame.Holder.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Toggle:Set(not Tab.Flags[Toggle.Flag], false)
					end
				end)

				Toggle:Set(options.default == true, true)

				return Toggle
			end

			-- Label

			function Section:AddLabel(name)
				local Label = {
					Name = name,
					Type = "Label",
				}

				Label.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 2, 0.5, 0),
							Size = UDim2.new(1, -4, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}),
					}, UDim.new(0, 5))
				}, UDim.new(0, 5))

				-- Scripts

				Section.List[#Section.List + 1] = Label
				Label.Frame.Parent = Section.Frame.List

				return Label
			end

			-- DualLabel

			function Section:AddDualLabel(options)
				local DualLabel = {
					Name = options[1].. " ".. options[2],
					Type = "DualLabel",
				}

				DualLabel.Frame = Utils.Create("Frame", {
					Name = options[1].. " ".. options[2],
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label1",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, 0),
							Size = UDim2.new(0.5, -5, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = options[1],
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						Utils.Create("TextLabel", {
							Name = "Label2",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0.5, 0, 0.5, 0),
							Size = UDim2.new(0.5, -5, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = options[2],
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Right,
						}),
					}, UDim.new(0, 5))
				}, UDim.new(0, 5))

				-- Scripts

				Section.List[#Section.List + 1] = DualLabel
				DualLabel.Frame.Parent = Section.Frame.List

				return DualLabel
			end

			-- ClipboardLabel

			function Section:AddClipboardLabel(name, callback)
				local ClipboardLabel = {
					Name = name,
					Type = "ClipboardLabel",
					Callback = callback,
				}

				ClipboardLabel.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 22),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							AnchorPoint = Vector2.new(0, 0.5),
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 2, 0.5, 0),
							Size = UDim2.new(1, -22, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}),

						Utils.Create("ImageLabel", {
							Name = "Icon",
							BackgroundTransparency = 1,
							Position = UDim2.new(1, -18, 0, 2),
							Size = UDim2.new(0, 16, 0, 16),
							Image = "rbxassetid://9243581053",
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Scripts

				Section.List[#Section.List + 1] = ClipboardLabel
				ClipboardLabel.Frame.Parent = Section.Frame.List

				ClipboardLabel.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						setclipboard(ClipboardLabel.Callback())
					end
				end)

				return ClipboardLabel
			end

			-- Box

			function Section:AddBox(name, options, callback)
				local Box = {
					Name = name,
					Type = "Box",
					Callback = callback,
				}

				Box.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -135, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						Utils.Create("Frame", {
							Name = "TextBox",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = Utils.Colors.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
							Position = UDim2.new(1, -2, 0, 2),
							Size = UDim2.new(0, 140, 1, -4),
							ZIndex = 2,

							Utils.Create("Frame", {
								Name = "Holder",
								BackgroundColor3 = Library.Theme.SectionColor,
								Position = UDim2.new(0, 1, 0, 1),
								Size = UDim2.new(1, -2, 1, -2),
								ZIndex = 2,

								Utils.Create("TextBox", {
									Name = "Box",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									ClearTextOnFocus = options.clearonfocus == true,
									Position = UDim2.new(0, 28, 0.5, 0),
									Size = UDim2.new(1, -30, 1, 0),
									Font = Enum.Font.SourceSans,
									PlaceholderText = "Text",
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
								}),

								Utils.Create("TextLabel", {
									Name = "Icon",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 6, 0.5, 0),
									Size = UDim2.new(0, 14, 0, 14),
									Font = Enum.Font.SourceSansBold,
									Text = "T",
									TextColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(40, 40, 40)),
									TextSize = 18,
									TextWrapped = true,
								}),
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5))
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Functions

				local function extendBox(bool)
					tween(Box.Frame.Holder.TextBox, 0.25, { Size = UDim2.new(0, bool and 200 or 140, 1, -4) })
				end

				-- Scripts

				Section.List[#Section.List + 1] = Box
				Box.Frame.Parent = Section.Frame.List

				Box.Frame.Holder.TextBox.Holder.MouseEnter:Connect(function()
					extendBox(true)
				end)

				Box.Frame.Holder.TextBox.Holder.MouseLeave:Connect(function()
					if Box.Frame.Holder.TextBox.Holder.Box:IsFocused() == false then
						extendBox(false)
					end
				end)

				Box.Frame.Holder.TextBox.Holder.Box.FocusLost:Connect(function()
					if Box.Frame.Holder.TextBox.Holder.Box.Text == "" and options.fireonempty ~= true then
						return
					end

					extendBox(false)
					task.spawn(Box.Callback, Box.Frame.Holder.TextBox.Holder.Box.Text)
				end)

				return Box
			end

			-- Bind

			function Section:AddBind(name, bind, options, callback)
				local Bind = {
					Name = name,
					Type = "Bind",
					Bind = bind,
					Flag = options.flag or name,
					Callback = callback,
				}

				Bind.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 32),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0.5, -7),
							Size = UDim2.new(1, -135, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						Utils.Create("Frame", {
							Name = "Bind",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
							Position = UDim2.new(1, options.toggleable == true and -44 or -2, 0, 2),
							Size = UDim2.new(0, 78, 0, 26),
							ZIndex = 2,

							Utils.Create("TextLabel", {
								Name = "Label",
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
								Position = UDim2.new(0, 1, 0, 1),
								Size = UDim2.new(1, -2, 1, -2),
								Font = Enum.Font.SourceSans,
								Text = "",
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
							}, UDim.new(0, 5)),
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local indicatorEntered = false
				local connections = {}

				-- Functions

				local function listenForBind()
					if connections.listen then
						connections.listen:Disconnect()
					end

					Bind.Frame.Holder.Bind.Label.Text = "..."

					connections.listen = UIS.InputBegan:Connect(function(input, gameProcessed)
						if gameProcessed == false and input.UserInputType == Enum.UserInputType.Keyboard then
							Bind:Set(input.KeyCode)
						end
					end)
				end

				local function cancelListen()
					if connections.listen then
						connections.listen:Disconnect()
						connections.listen = nil
					end

					Bind.Frame.Holder.Bind.Label.Text = Bind.Bind.Name
				end

				function Bind:Set(bind)
					if connections.listen then
						cancelListen()
					end

					Bind.Bind = bind
					Bind.Frame.Holder.Bind.Label.Text = bind.Name
					Bind.Frame.Holder.Bind.Size = UDim2.new(0, math.max(12 + math.round(TXS:GetTextSize(bind.Name, 14, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5), 42), 0, 26)
				end

				if options.toggleable == true then
					function Bind:Toggle(bool, instant)
						Tab.Flags[Bind.Flag] = bool

						if options.fireontoggle == true then
							task.spawn(Bind.Callback)
						end

						tween(Bind.Frame.Holder.Indicator.Overlay, 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Bind.Frame.Holder.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.Accent, Color3.fromRGB(50, 50, 50)) or Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })
					end
				end

				-- Scripts

				Section.List[#Section.List + 1] = Bind
				Bind.Frame.Parent = Section.Frame.List

				Bind.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if indicatorEntered == true then
							Bind:Toggle(not Tab.Flags[Bind.Flag], false)
						else
							listenForBind()
						end
					end
				end)

				UIS.InputBegan:Connect(function(input)
					if input.KeyCode == Bind.Bind then
						if options.toggleable == true and Tab.Flags[Bind.Flag] == false then
							return
						end

						task.spawn(Bind.Callback)
					end
				end)

				if options.toggleable == true then
					local indicator = Utils.Create("Frame", {
						Name = "Indicator",
						AnchorPoint = Vector2.new(1, 0),
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Position = UDim2.new(1, -2, 0, 2),
						Size = UDim2.new(0, 40, 0, 26),

						Utils.Create("ImageLabel", {
							Name = "Overlay",
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(0, 22, 0, 22),
							Image = "http://www.roblox.com/asset/?id=7827504335",
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Scripts

					Tab.Flags[Bind.Flag] = options.default == true
					indicator.Parent = Bind.Frame.Holder

					Bind.Frame.Holder.Indicator.MouseEnter:Connect(function()
						indicatorEntered = true
					end)

					Bind.Frame.Holder.Indicator.MouseLeave:Connect(function()
						indicatorEntered = false
					end)

					Bind:Toggle(options.default == true, true)
				end

				Bind:Set(Bind.Bind)

				return Bind
			end

			-- Slider

			function Section:AddSlider(name, min, max, default, options, callback)
				local Slider = {
					Name = name,
					Type = "Slider",
					Value = default,
					Flag = options.flag or name,
					Callback = callback,
				}

				Slider.Frame = Utils.Create("Frame", {
					Name = name,
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 41),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("TextLabel", {
							Name = "Label",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 0, 5),
							Size = UDim2.new(1, -75, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Left,
						}),

						Utils.Create("Frame", {
							Name = "Slider",
							BackgroundTransparency = 1,
							Position = UDim2.new(0, 5, 1, -15),
							Size = UDim2.new(1, -10, 0, 10),

							Utils.Create("Frame", {
								Name = "Bar",
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								ClipsDescendants = true,
								Size = UDim2.new(1, 0, 1, 0),

								Utils.Create("Frame", {
									Name = "Fill",
									BackgroundColor3 = Utils.Colors.Sub(Library.Theme.Accent, Color3.fromRGB(50, 50, 50)),
									Size = UDim2.new(0.5, 0, 1, 0),
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5)),

							Utils.Create("Frame", {
								Name = "Point",
								AnchorPoint = Vector2.new(0.5, 0.5),
								BackgroundColor3 = Library.Theme.Accent,
								Position = UDim2.new(0.5, 0, 0.5, 0),
								Size = UDim2.new(0, 12, 0, 12),
							}, UDim.new(0, 5)),
						}),

						Utils.Create("TextBox", {
							Name = "Input",
							AnchorPoint = Vector2.new(1, 0),
							BackgroundTransparency = 1,
							PlaceholderText = "...",
							Position = UDim2.new(1, -5, 0, 5),
							Size = UDim2.new(0, 60, 0, 14),
							Font = Enum.Font.SourceSans,
							Text = "",
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
							TextXAlignment = Enum.TextXAlignment.Right,
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local connections = {}

				-- Functions

				local function getSliderValue(val)
					val = math.clamp(val, min, max)

					if options.rounded == true then
						val = math.floor(val)
					end

					return val
				end

				local function sliderVisual(val)
					val = getSliderValue(val)

					Slider.Frame.Holder.Input.Text = val

					local valuePercent = 1 - ((max - val) / (max - min))
					local pointPadding = 1 / Slider.Frame.Holder.Slider.AbsoluteSize.X * 5
					tween(Slider.Frame.Holder.Slider.Bar.Fill, 0.25, { Size = UDim2.new(valuePercent, 0, 1, 0) })
					tween(Slider.Frame.Holder.Slider.Point, 0.25, { Position = UDim2.fromScale(math.clamp(valuePercent, pointPadding, 1 - pointPadding), 0.5) })
				end

				function Slider:Set(val)
					val = getSliderValue(val)

					Slider.Value = val
					sliderVisual(val)

					if options.toggleable == false or options.toggleable == true and Tab.Flags[Slider.Flag] ~= false then
						task.spawn(Slider.Callback, val, options.toggleable and Tab.Flags[Slider.Flag] or nil)
					end
				end

				if options.toggleable == true then
					function Slider:Toggle(bool, instant)
						Tab.Flags[Slider.Flag] = bool

						if options.fireontoggle == true then
							task.spawn(Slider.Callback, Slider.Value, bool)
						end

						tween(Slider.Frame.Holder.Indicator.Overlay, 0.25, { ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
						tween(Slider.Frame.Holder.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.Accent, Color3.fromRGB(50, 50, 50)) or Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })
					end
				end

				-- Scripts

				Section.List[#Section.List + 1] = Slider
				Slider.Frame.Parent = Section.Frame.List

				Slider.Frame.Holder.Slider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then

						connections.move = Mouse.Move:Connect(function()
							local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
							local sliderValue = math.floor((min + sliderPercent * (max - min)) * 10) / 10

							if options.fireondrag == true then
								Slider:Set(sliderValue)
							else
								sliderVisual(sliderValue)
							end
						end)

					end
				end)

				Slider.Frame.Holder.Slider.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						connections.move:Disconnect()
						connections.move = nil

						if options.fireondrag == false then
							local sliderPercent = math.clamp((Mouse.X - Slider.Frame.Holder.Slider.AbsolutePosition.X) / Slider.Frame.Holder.Slider.AbsoluteSize.X, 0, 1)
							local sliderValue = math.floor((min + sliderPercent * (max - min)) * 10) / 10

							Slider:Set(sliderValue)
						end
					end
				end)

				Slider.Frame.Holder.Input.FocusLost:Connect(function()
					Slider.Frame.Holder.Input.Text = string.sub(Slider.Frame.Holder.Input.Text, 1, 10)

					if tonumber(Slider.Frame.Holder.Input.Text) then
						Slider:Set(Slider.Frame.Holder.Input.Text)
					end
				end)

				if options.toggleable == true then
					local indicator = Utils.Create("Frame", {
						Name = "Indicator",
						AnchorPoint = Vector2.new(1, 1),
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
						Position = UDim2.new(1, -2, 1, -2),
						Size = UDim2.new(0, 40, 0, 26),

						Utils.Create("ImageLabel", {
							Name = "Overlay",
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
							Position = UDim2.new(0, 2, 0, 2),
							Size = UDim2.new(0, 22, 0, 22),
							Image = "http://www.roblox.com/asset/?id=7827504335",
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Scripts

					Tab.Flags[Slider.Flag] = options.default == true
					Slider.Frame.Size = UDim2.new(1, 2, 0, 54)
					Slider.Frame.Holder.Slider.Size = UDim2.new(1, -50, 0, 10)
					indicator.Parent = Slider.Frame.Holder

					Slider.Frame.Holder.Indicator.InputBegan:Connect(function(input)
						if input.UserInputType == Enum.UserInputType.MouseButton1 then
							Slider:Toggle(not Tab.Flags[Slider.Flag], false)
						end
					end)

					Slider:Toggle(options.default == true, true)
				end

				Slider:Set(Slider.Value)

				return Slider
			end

			-- Dropdown

			function Section:AddDropdown(name, list, callback)
				local Dropdown = {
					Name = name,
					Type = "Dropdown",
					Callback = callback,
					Toggled = false,
					List = {},
				}

				Dropdown.Frame = Utils.Create("Frame", {
					Name = "Dropdown",
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					Size = UDim2.new(1, 2, 0, 42),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("Frame", {
							Name = "Holder",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 40),

							Utils.Create("Frame", {
								Name = "Displays",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0, 8),
								Size = UDim2.new(1, -35, 0, 14),

								Utils.Create("TextLabel", {
									Name = "Label",
									BackgroundTransparency = 1,
									Size = UDim2.new(0.5, 0, 1, 0),
									Font = Enum.Font.SourceSans,
									Text = name,
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),

								Utils.Create("TextLabel", {
									Name = "Selected",
									BackgroundTransparency = 1,
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(0.5, 0, 1, 0),
									Font = Enum.Font.SourceSans,
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Right,
								}),
							}),

							Utils.Create("ImageLabel", {
								Name = "Indicator",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 5),
								Size = UDim2.new(0, 20, 0, 20),
								Image = "rbxassetid://9243354333",
							}),

							Utils.Create("Frame", {
								Name = "Line",
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 30),
								Size = UDim2.new(1, -10, 0, 2),
							}),
						}, UDim.new(0, 5)),

						Utils.Create("ScrollingFrame", {
							Name = "List",
							Active = true,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 5, 0, 40),
							Size = UDim2.new(1, -10, 1, -40),
							CanvasSize = UDim2.new(0, 0, 0, 0),
							ScrollBarImageColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
							ScrollBarThickness = 5,

							Utils.Create("UIListLayout", {
								SortOrder = Enum.SortOrder.LayoutOrder,
								Padding = UDim.new(0, 5),
							}),
						}),
					}, UDim.new(0,5)),
				}, UDim.new(0, 5))

				-- Functions

				function Dropdown:GetHeight()
					return 42 + (Dropdown.Toggled == true and math.min(#Dropdown.List, 5) * 27 or 0)
				end

				function Dropdown:UpdateHeight()
					Dropdown.Frame.Size = UDim2.new(1, 2, 0, Dropdown:GetHeight())
					Dropdown.Frame.Holder.List.CanvasSize = UDim2.new(0, 0, 0, #Dropdown.List * 27 - 5)

					Section:UpdateHeight()
					Tab:UpdateHeight()
				end

				function Dropdown:Add(name, options, callback)
					local Item = {
						Name = name,
						Callback = callback,
					}

					Item.Frame = Utils.Create("Frame", {
						Name = name,
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(20, 20, 20)),
						Size = UDim2.new(1, -10, 0, 22),

						Utils.Create("TextButton", {
							Name = "Button",
							BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
							Position = UDim2.new(0, 1, 0, 1),
							Size = UDim2.new(1, -2, 1, -2),
							Font = Enum.Font.SourceSans,
							Text = name,
							TextColor3 = Library.Theme.TextColor,
							TextSize = 14,
							TextWrapped = true,
						}, UDim.new(0, 5)),
					}, UDim.new(0, 5))

					-- Scripts

					Dropdown.List[#Dropdown.List + 1] = Item
					Item.Frame.Parent = Dropdown.Frame.Holder.List

					if Dropdown.Toggled == true then
						Dropdown:UpdateHeight()
					end

					Item.Frame.Button.Activated:Connect(function()
						if typeof(Item.Callback) == "function" then
							task.spawn(Item.Callback)
						else
							Dropdown:Select(Item.Name)
						end
					end)
				end

				function Dropdown:Remove(name)
					for i, v in next, Dropdown.List do
						if v.Name == name then
							v.Frame:Destroy()
							table.remove(Dropdown.List, i)

							if Dropdown.Toggled == true then
								Dropdown:UpdateHeight()
							end

							break
						end
					end

					if #Dropdown.List == 0 then
						Dropdown:Toggle(false)
					end
				end

				function Dropdown:Select(itemName)
					Dropdown.Frame.Holder.Holder.Displays.Selected.Text = itemName
					Dropdown:Toggle(false)

					task.spawn(Dropdown.Callback, itemName)
				end

				function Dropdown:Toggle(bool)
					Dropdown.Toggled = bool

					tween(Dropdown.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Dropdown:GetHeight()) })
					tween(Dropdown.Frame.Holder.Holder.Indicator, 0.5, { Rotation = bool and 90 or 0 })
					tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
					tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
				end

				-- Scripts

				Section.List[#Section.List + 1] = Dropdown
				Dropdown.Frame.Parent = Section.Frame.List

				Dropdown.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and #Dropdown.List > 0 and Mouse.Y - Dropdown.Frame.AbsolutePosition.Y <= 30 then
						Dropdown:Toggle(not Dropdown.Toggled)
					end
				end)

				for i, v in next, list do
					Dropdown:Add(v)
				end

				return Dropdown
			end

			-- Picker

			function Section:AddPicker(name, options, callback)
				local Picker = {
					Name = name,
					Type = "Picker",
					Toggled = false,
					Rainbow = false,
					Callback = callback,
				}

				local h, s, v = (options.color or Color3.fromRGB(255, 0, 0)):ToHSV()
				Picker.Color = { R = h, G = s, B = v }

				Picker.Frame = Utils.Create("Frame", {
					Name = "ColorPicker",
					BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
					ClipsDescendants = true,
					Size = UDim2.new(1, 2, 0, 42),

					Utils.Create("Frame", {
						Name = "Holder",
						BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
						ClipsDescendants = true,
						Position = UDim2.new(0, 1, 0, 1),
						Size = UDim2.new(1, -2, 1, -2),

						Utils.Create("Frame", {
							Name = "Top",
							BackgroundTransparency = 1,
							Size = UDim2.new(1, 0, 0, 40),

							Utils.Create("TextLabel", {
								Name = "Label",
								BackgroundTransparency = 1,
								Position = UDim2.new(0, 5, 0, 8),
								Size = UDim2.new(0.5, -15, 0, 14),
								Font = Enum.Font.SourceSans,
								Text = name,
								TextColor3 = Library.Theme.TextColor,
								TextSize = 14,
								TextWrapped = true,
								TextXAlignment = Enum.TextXAlignment.Left,
							}),

							Utils.Create("Frame", {
								Name = "Selected",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								Position = UDim2.new(1, -29, 0, 2),
								Size = UDim2.new(0, 100, 0, 26),

								Utils.Create("Frame", {
									Name = "Preview",
									BackgroundColor3 = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B),
									Position = UDim2.new(0, 1, 0, 1),
									Size = UDim2.new(1, -2, 1, -2),
								}, UDim.new(0, 5)),

								Utils.Create("TextLabel", {
									Name = "Display",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0.5, 0),
									Size = UDim2.new(1, 0, 0, 16),
									Font = Enum.Font.SourceSans,
									Text = "",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 16,
									TextStrokeColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
									TextStrokeTransparency = 0.5,
								}),
							}, UDim.new(0, 5)),

							Utils.Create("ImageLabel", {
								Name = "Indicator",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 5),
								Size = UDim2.new(0, 20, 0, 20),
								Image = "rbxassetid://9243354333",
							}),

							Utils.Create("Frame", {
								Name = "Line",
								BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 30),
								Size = UDim2.new(1, -10, 0, 2),
							}),
						}),

						Utils.Create("Frame", {
							Name = "Holder",
							Active = true,
							BackgroundTransparency = 1,
							BorderSizePixel = 0,
							Position = UDim2.new(0, 0, 0, 40),
							Size = UDim2.new(1, 0, 1, -40),

							Utils.Create("Frame", {
								Name = "Palette",
								BackgroundTransparency = 1,
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 5),
								Size = UDim2.new(1, -196, 0, 110),

								Utils.Create("Frame", {
									Name = "Point",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Utils.Colors.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
									Position = UDim2.new(1, 0, 0, 0),
									Size = UDim2.new(0, 7, 0, 7),
									ZIndex = 2,

									Utils.Create("Frame", {
										Name = "Inner",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Position = UDim2.new(0, 1, 0, 1),
										Size = UDim2.new(1, -2, 1, -2),
										ZIndex = 2,
									}, UDim.new(1, 0)),
								}, UDim.new(1, 0)),

								Utils.Create("Frame", {
									Name = "Hue",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 1, 0),

									Utils.Create("UIGradient", {
										Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B))},
									}),
								}, UDim.new(0, 5)),

								Utils.Create("Frame", {
									Name = "SatVal",
									BackgroundColor3 = Color3.fromRGB(255, 255, 255),
									BorderSizePixel = 0,
									Size = UDim2.new(1, 0, 1, 0),
									ZIndex = 2,

									Utils.Create("UIGradient", {
										Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0))},
										Rotation = 90,
										Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 1.00), NumberSequenceKeypoint.new(1.00, 0.00)},
									}),
								}, UDim.new(0, 5)),
							}),

							Utils.Create("Frame", {
								Name = "HueSlider",
								BackgroundColor3 = Color3.fromRGB(255, 255, 255),
								BorderSizePixel = 0,
								Position = UDim2.new(0, 5, 0, 125),
								Size = UDim2.new(1, -10, 0, 20),

								Utils.Create("UIGradient", {
									Color = ColorSequence.new{
										ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
										ColorSequenceKeypoint.new(0.16666, Color3.fromRGB(255, 255, 0)),
										ColorSequenceKeypoint.new(0.33333, Color3.fromRGB(0, 255, 0)),
										ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
										ColorSequenceKeypoint.new(0.66667, Color3.fromRGB(0, 0, 255)),
										ColorSequenceKeypoint.new(0.83333, Color3.fromRGB(255, 0, 255)),
										ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
									},
								}),

								Utils.Create("Frame", {
									Name = "Bar",
									AnchorPoint = Vector2.new(0.5, 0.5),
									BackgroundColor3 = Utils.Colors.Sub(Library.Theme.SectionColor, Color3.fromRGB(5, 5, 5)),
									Position = UDim2.new(0.5, 0, 0, 0),
									Size = UDim2.new(0, 6, 1, 6),

									Utils.Create("Frame", {
										Name = "Inner",
										BackgroundColor3 = Color3.fromRGB(255, 255, 255),
										Position = UDim2.new(0, 1, 0, 1),
										Size = UDim2.new(1, -2, 1, -2),
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							}, UDim.new(0, 5)),

							Utils.Create("Frame", {
								Name = "RGB",
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -180, 0, 5),
								Size = UDim2.new(0, 75, 0, 110),

								Utils.Create("Frame", {
									Name = "Red",
									BackgroundTransparency = 1,
									Size = UDim2.new(1, 0, 0, 30),

									Utils.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "R",
										Text = 255,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								Utils.Create("Frame", {
									Name = "Green",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0, 40),
									Size = UDim2.new(1, 0, 0, 30),

									Utils.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "G",
										Text = 0,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),

								Utils.Create("Frame", {
									Name = "Blue",
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 0, 0, 80),
									Size = UDim2.new(1, 0, 0, 30),

									Utils.Create("TextBox", {
										Name = "Box",
										BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(10, 10, 10)),
										Size = UDim2.new(1, 0, 1, 0),
										Font = Enum.Font.SourceSans,
										PlaceholderText = "B",
										Text = 0,
										TextColor3 = Library.Theme.TextColor,
										TextSize = 16,
										TextWrapped = true,
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							}),

							Utils.Create("Frame", {
								Name = "Rainbow",
								AnchorPoint = Vector2.new(1, 0),
								BackgroundTransparency = 1,
								Position = UDim2.new(1, -5, 0, 87),
								Size = UDim2.new(0, 90, 0, 26),

								Utils.Create("TextLabel", {
									Name = "Label",
									AnchorPoint = Vector2.new(0, 0.5),
									BackgroundTransparency = 1,
									Position = UDim2.new(0, 47, 0.5, 0),
									Size = UDim2.new(1, -47, 0, 14),
									Font = Enum.Font.SourceSans,
									Text = "Rainbow",
									TextColor3 = Library.Theme.TextColor,
									TextSize = 14,
									TextWrapped = true,
									TextXAlignment = Enum.TextXAlignment.Left,
								}),

								Utils.Create("Frame", {
									Name = "Indicator",
									BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(15, 15, 15)),
									Size = UDim2.new(0, 40, 0, 26),

									Utils.Create("ImageLabel", {
										Name = "Overlay",
										BackgroundColor3 = Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)),
										Size = UDim2.new(0, 24, 0, 24),
										Image = "http://www.roblox.com/asset/?id=7827504335",
									}, UDim.new(0, 5)),
								}, UDim.new(0, 5)),
							})
						}),
					}, UDim.new(0, 5)),
				}, UDim.new(0, 5))

				-- Variables

				local hueDragging, satDragging = false, false

				-- Functions

				function Picker:GetHeight()
					return Picker.Toggled == true and 192 or 42
				end

				function Picker:Toggle(bool)
					Picker.Toggled = bool

					tween(Picker.Frame, 0.5, { Size = UDim2.new(1, 2, 0, Picker:GetHeight()) })
					tween(Picker.Frame.Holder.Top.Indicator, 0.5, { Rotation = bool and 90 or 0 })
					tween(Section.Frame, 0.5, { Size = UDim2.new(1, -10, 0, Section:GetHeight()) })
					tween(Tab.Frame, 0.5, { CanvasSize = UDim2.new(0, 0, 0, Tab:GetHeight()) })
				end

				function Picker:ToggleRainbow(bool)
					Picker.Rainbow = bool

					tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, 0.25, {ImageTransparency = bool and 0 or 1, Position = bool and UDim2.new(1, -24, 0, 2) or UDim2.new(0, 2, 0, 2) })
					tween(Picker.Frame.Holder.Holder.Rainbow.Indicator.Overlay, "Cosmetic", 0.25, { BackgroundColor3 = bool and Utils.Colors.Add(Library.Theme.Accent, Color3.fromRGB(50, 50, 50)) or Utils.Colors.Add(Library.Theme.SectionColor, Color3.fromRGB(25, 25, 25)) })

					if bool then
						if not Storage.Connections[Picker] then
							Storage.Connections[Picker] = {}
						end

						Storage.Connections[Picker].Rainbow = RS.Heartbeat:Connect(function()
							Picker:Set(tick() % 5 / 5, Picker.Color.G, Picker.Color.B)
						end)

					elseif Storage.Connections[Picker] then
						Storage.Connections[Picker].Rainbow:Disconnect()
						Storage.Connections[Picker].Rainbow = nil
					end
				end

				function Picker:Set(h, s, v)
					Picker.Color.R, Picker.Color.G, Picker.Color.B = h, s, v

					local color = Color3.fromHSV(h, s, v)
					Picker.Frame.Holder.Holder.Palette.Hue.UIGradient.Color = ColorSequence.new(Color3.new(1, 1, 1), Color3.fromHSV(h, 1, 1))
					Picker.Frame.Holder.Top.Selected.Preview.BackgroundColor3 = color
					Picker.Frame.Holder.Top.Selected.Display.Text = string.format("%d, %d, %d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
					Picker.Frame.Holder.Top.Selected.Size = UDim2.new(0, math.round(TXS:GetTextSize(Picker.Frame.Holder.Top.Selected.Display.Text, 16, Enum.Font.SourceSans, Vector2.new(9e9)).X + 0.5) + 20, 0, 26)

					Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
					Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.G * 255 + 0.5)
					Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)

					tween(Picker.Frame.Holder.Holder.HueSlider.Bar, 0.1, { Position = UDim2.new(h, 0, 0.5, 0) })
					tween(Picker.Frame.Holder.Holder.Palette.Point, 0.1, { Position = UDim2.new(s, 0, 1 - v, 0) })

					task.spawn(Picker.Callback, color)
				end

				-- Scripts

				Section.List[#Section.List + 1] = Picker
				Picker.Frame.Parent = Section.Frame.List

				Picker.Frame.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 and Mouse.Y - Picker.Frame.AbsolutePosition.Y <= 30 then
						Picker:Toggle(not Picker.Toggled)
					end
				end)

				Picker.Frame.Holder.Holder.HueSlider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDragging = true
					end
				end)

				Picker.Frame.Holder.Holder.HueSlider.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						hueDragging = false
					end
				end)

				Picker.Frame.Holder.Holder.Palette.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						satDragging = true
					end
				end)

				Picker.Frame.Holder.Holder.Palette.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						satDragging = false
					end
				end)

				Mouse.Move:Connect(function()
					if hueDragging then
						Picker:Set(math.clamp((Mouse.X - Picker.Frame.Holder.Holder.HueSlider.AbsolutePosition.X) / Picker.Frame.Holder.Holder.HueSlider.AbsoluteSize.X, 0, 1), Picker.Color.G, Picker.Color.B)

					elseif satDragging then
						Picker:Set(Picker.Color.R, math.clamp((Mouse.X - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.X) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.X, 0, 1), 1 - math.clamp((Mouse.Y - Picker.Frame.Holder.Holder.Palette.AbsolutePosition.Y) / Picker.Frame.Holder.Holder.Palette.AbsoluteSize.Y, 0, 1))
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Red.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Red.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(math.clamp(math.floor(num), 0, 255) / 255, color.G, color.B):ToHSV())
					else
						Picker.Frame.Holder.Holder.RGB.Red.Box.Text = math.floor(color.R * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Green.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Green.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(color.R, math.clamp(math.floor(num), 0, 255) / 255, color.B):ToHSV() )
					else
						Picker.Frame.Holder.Holder.RGB.Green.Box.Text = math.floor(color.B * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.RGB.Blue.Box.FocusLost:Connect(function()
					local num = tonumber(Picker.Frame.Holder.Holder.RGB.Blue.Box.Text)
					local color = Color3.fromHSV(Picker.Color.R, Picker.Color.G, Picker.Color.B)

					if num then
						Picker:Set(Color3.new(color.R, color.G, math.clamp(math.floor(num), 0, 255) / 255):ToHSV())
					else
						Picker.Frame.Holder.Holder.RGB.Blue.Box.Text = math.floor(color.B * 255 + 0.5)
					end
				end)

				Picker.Frame.Holder.Holder.Rainbow.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						Picker:ToggleRainbow(not Picker.Rainbow)
					end
				end)

				Picker:Set(Picker.Color.R, Picker.Color.G, Picker.Color.B)

				return Picker
			end

			return Section
		end

		return Tab
	end

	return Window
end

-- Scripts

return Library