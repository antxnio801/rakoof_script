local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
ESP:Toggle(false); ESP.Names = true; ESP.Tracers = false; ESP.Boxes = false; ESP.Players = false;

local LP = game:GetService("Players").LocalPlayer
local Character = LP.Character or LP.CharacterAdded:Wait()

local Humanoid = Character:FindFirstChildOfClass("Humanoid")
local RootPart = Character:FindFirstChild("HumanoidRootPart")

local CharValues = Character:FindFirstChild("CharValues")

local leaderstats = LP:FindFirstChild("leaderstats")
local PointsValue = leaderstats:FindFirstChild("Points")

local Window = Fluent:CreateWindow({
	
	Title = "Luna Hub",
	SubTitle = "v0.0.1",
	
	TabWidth = 160,
	Size = UDim2.fromOffset(580, 460),
	
	Acrylic = false,
	Theme = "Dark",
	
	MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
	
	Information = Window:AddTab({ Title = "Information", Icon = "" }),
	Main = Window:AddTab({ Title = "Main", Icon = "" }),
	
	ESP = Window:AddTab({ Title = "ESP", Icon = "" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "" }),
}

Window:SelectTab(1)
local Options = Fluent.Options

------------// INFORMATION \\------------

local main_gameTimer_text = Tabs.Information:AddParagraph({
	
	Title = "Game Timer",
	Content = "Value: 0"
})

local main_powerTimer_text = Tabs.Information:AddParagraph({
	
	Title = "Power Timer",
	Content = "Value: 0"
})

local main_rakeHealth_text = Tabs.Information:AddParagraph({

	Title = "RakOOF Health",
	Content = "Health: 0"
})

local main_hourMode_text = Tabs.Information:AddParagraph({

	Title = "Current Hour",
	Content = "Mode: None"
})

------------// MAIN \\------------

local main_stamina_toggle = Tabs.Main:AddToggle("main_stamina_toggle", { Title = "Infinite Stamina", Default = false })
local main_rakeHitbox_toggle = Tabs.Main:AddToggle("main_rakeHitbox_toggle", { Title = "Hit rake anywere", Default = false })

local main_autofarm_toggle = Tabs.Main:AddToggle("main_autofarm_toggle", { Title = "Survivals Autofarm", Default = false })

main_autofarm_toggle:OnChanged(function()
	
	if Options.main_autofarm_toggle.Value == false then return end
	
	if rake_autofarm_connection then

		pcall(function() coroutine.close(rake_autofarm_connection) end)
		rake_autofarm_connection = nil
	end

	getgenv().rake_autofarm_connection = autofarm_function
	rake_autofarm_connection()
end)

Tabs.Main:AddButton({

	Title = "Infinite Loot",
	--Description = "Very important button",

	Callback = function()
		
		for _, v in pairs(workspace:WaitForChild("Filter"):WaitForChild("Lootable"):GetDescendants()) do
			if v:IsA("ProximityPrompt") then
				
				v.HoldDuration = 0
				
				v.Changed:Connect(function()
					v.Enabled = true
				end)
			end
		end
	end
})

Tabs.Main:AddButton({
	
	Title = "Toggle Day/Night",
	--Description = "Very important button",
	
	Callback = function()
		
		pcall(function()

			if Options.main_day_loop_toggle.Value then

				Window:Dialog({

					Title = "Action denied",
					Content = `You must need to disbale "Always day" toggle. Do you want to disable it?`,

					Buttons = {

						{
							Title = "Yes",

							Callback = function()

								Options.main_day_loop_toggle:SetValue(false)
								game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value = not game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value
							end
						},

						{
							Title = "No",
						}
					}
				})

				return 
			end
		end)

		game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value = not game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value
	end
})

local main_day_loop_toggle = Tabs.Main:AddToggle("main_day_loop_toggle", { Title = "Always Day", Default = false })

main_day_loop_toggle:OnChanged(function()
	game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value = Options.main_day_loop_toggle.Value
end)

------------// ESP \\------------

local esp_toggle = Tabs.ESP:AddToggle("esp_toggle", { Title = "Toggle ESP", Default = false })

esp_toggle:OnChanged(function()	
	ESP:Toggle(Options.esp_toggle.Value);
end)

Options.esp_toggle:SetValue(true)

local esp_players_toggle = Tabs.ESP:AddToggle("esp_players_toggle", { Title = "Players ESP", Default = false })

esp_players_toggle:OnChanged(function()
	ESP.Players = Options.esp_players_toggle.Value
end)

local esp_rake_toggle = Tabs.ESP:AddToggle("esp_rake_toggle", { Title = "Rake ESP", Default = false })

esp_rake_toggle:OnChanged(function()
	ESP.rake = Options.esp_rake_toggle.Value
end)

local esp_locations_toggle = Tabs.ESP:AddToggle("esp_locations_toggle", { Title = "Locations ESP", Default = false })

esp_locations_toggle:OnChanged(function()
	ESP.locations = Options.esp_locations_toggle.Value
end)

local esp_joseDucks_toggle = Tabs.ESP:AddToggle("esp_joseDucks_toggle", { Title = "Jose Ducks ESP", Default = false })

esp_joseDucks_toggle:OnChanged(function()
	ESP.joseducks = Options.esp_joseDucks_toggle.Value
end)

local esp_tarcers_toggle = Tabs.ESP:AddToggle("esp_tarcers_toggle", { Title = "Toggle Tracers", Default = false })

esp_tarcers_toggle:OnChanged(function()
	ESP.Tracers = Options.esp_tarcers_toggle.Value
end)

local esp_boxes_toggle = Tabs.ESP:AddToggle("esp_boxes_toggle", { Title = "Toggle Boxes", Default = false })

esp_boxes_toggle:OnChanged(function()
	ESP.Boxes = Options.esp_boxes_toggle.Value
end)

------------// MISC \\------------

Tabs.Misc:AddButton({

	Title = "Remove Power Station Damage",
	--Description = "Very important button",

	Callback = function() pcall(function()
		workspace:WaitForChild("LocationsFolder"):WaitForChild("PowerStation"):WaitForChild("BarbedWire"):WaitForChild("BarbedWire"):Destroy()
	end) end
})

Tabs.Misc:AddButton({

	Title = "Remove Shop Door",
	--Description = "Very important button",

	Callback = function() pcall(function()
		workspace:WaitForChild("LocationsFolder"):WaitForChild("Shop"):WaitForChild("ShopDoor"):Destroy()
		workspace:WaitForChild("LocationsFolder"):WaitForChild("Shop"):WaitForChild("InsideShopPart"):Destroy()
	end) end
})


local misc_bringRake_toggle = Tabs.Misc:AddToggle("misc_bringRake_toggle", { Title = "Bring RakOOF", Default = false })

------------// FUNCTIONS \\------------

local mt = getrawmetatable(game)
--make_writeable(mt)

local old_index = mt.__index

mt.__index = function(a, b)

	if tostring(a) == "StaminaPercentValue" and tostring(b) == "Value" and Options.main_stamina_toggle.Value then
		return 100
	end

	return old_index(a, b)
end

game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day"):GetPropertyChangedSignal("Value"):Connect(function()
	
	if game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value == false and Options.main_day_loop_toggle.Value then
		game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("Day").Value = true
	end
end)

game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("GameTimer"):GetPropertyChangedSignal("Value"):Connect(function()
	main_gameTimer_text:SetDesc(`Value: {game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("GameTimer").Value}`)
end)

game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("PowerTimer"):GetPropertyChangedSignal("Value"):Connect(function()
	main_powerTimer_text:SetDesc(`Value: {game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("PowerTimer").Value}`)
end)

local checkHourMode = function()
	
	local value = game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("CurrentActiveHour").Value

	if value == 0 then

		main_hourMode_text:SetDesc(`Mode: None`)

	elseif value == 1 then

		main_hourMode_text:SetDesc(`Mode: Blood Hour`)

	elseif value == 2 then

		main_hourMode_text:SetDesc(`Mode: Nightmare Hour`)

	elseif value == 3 then

		main_hourMode_text:SetDesc(`Mode: Corrupted Hour`)

	elseif value == 4 then

		main_hourMode_text:SetDesc(`Mode: Cheese Hour`)

	elseif value == 5 then

		main_hourMode_text:SetDesc(`Mode: Orange Hour`)
	end
end

game:GetService("ReplicatedStorage"):WaitForChild("Values"):WaitForChild("CurrentActiveHour"):GetPropertyChangedSignal("Value"):Connect(function()
	checkHourMode()
end)

checkHourMode()

game:GetService("RunService").RenderStepped:Connect(function()
	
	for _, v in pairs(workspace:GetChildren()) do
		
		if string.find(v.Name, "RakoofNPC") and v:FindFirstChildOfClass("Humanoid") then
			
			if Options.main_rakeHitbox_toggle.Value then
				
				pcall(function() v:WaitForChild("HumanoidRootPart").Size = Vector3.new(9999, 9999, 9999) end)
				
			else
				
				pcall(function() v:WaitForChild("HumanoidRootPart").Size = Vector3.new(2.385, 2.385, 1.192) end)
			end
			
			pcall(function()

				v:WaitForChild("HumanoidRootPart").HumanoidRootPart.Anchored = Options.misc_bringRake_toggle.Value

				if Options.misc_bringRake_toggle.Value then
					v:WaitForChild("HumanoidRootPart").HumanoidRootPart.CFrame = RootPart.CFrame + Vector3.new(3, 0, 0)
				end
			end)
			
			main_rakeHealth_text:SetDesc(`Health: {v:FindFirstChildOfClass("Humanoid").Health}`)
			
			v:FindFirstChildOfClass("Humanoid").Died:Connect(function()
				pcall(function() v:WaitForChild("HumanoidRootPart").Size = Vector3.new(2.385, 2.385, 1.192) end)
			end)
		end
	end
end)

ESP:AddObjectListener(workspace, {

	Name = "RakoofNPC",
	CustomName = "RakOOF",

	PrimaryPart = function(obj)
		local root = obj:FindFirstChild("HumanoidRootPart")

		while not root do 
			task.wait()
			root = obj:FindFirstChild("HumanoidRootPart")
		end

		return root 
	end, 

	Color = Color3.fromRGB(255, 0, 0),
	IsEnabled = "rake"
})

for _, v in pairs(workspace:WaitForChild("LocationsBillboardGuis"):GetChildren()) do
	if v:IsA("BasePart") or v:IsA("Part") then 


		ESP:Add(v, {

			Name = tostring(tostring(v.Name)),
			IsEnabled = "locations",
			
			Color = Color3.fromRGB(170, 255, 255)
		})
	end 
end

for _, v in pairs(workspace:WaitForChild("Filter"):WaitForChild("StuffGiversFolder"):WaitForChild("DuckParts"):GetChildren()) do
	if v:IsA("BasePart") or v:IsA("Part") then 


		ESP:Add(v, {

			Name = tostring(tostring(v.Name)),
			IsEnabled = "joseducks",

			Color = Color3.fromRGB(255, 255, 0)
		})
	end 
end

function autofarm_function()
	return coroutine.resume(coroutine.create(function()

		repeat task.wait()

			if Options.main_autofarm_toggle.Value == false then break end

			if LP.Backpack:FindFirstChild("Pan") ~= nil or Character:FindFirstChild("Pan") or PointsValue.Value >= 600 then
				break
			end

			Character = LP.Character or LP.CharacterAdded:Wait()

			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			RootPart = Character:FindFirstChild("HumanoidRootPart")

			repeat task.wait() until Humanoid ~= nil and RootPart ~= nil
			repeat task.wait() until Humanoid.Health > 0

			RootPart.CFrame = workspace.Filter.Lootable:GetChildren()[8].CFrame

			workspace.Filter.Lootable:GetChildren()[8].ProximityPrompt.HoldDuration = 0
			workspace.Filter.Lootable:GetChildren()[8].ProximityPrompt.Enabled = true

			fireproximityprompt(workspace.Filter.Lootable:GetChildren()[8].ProximityPrompt)

		until PointsValue.Value >= 600

		repeat task.wait()

			if Options.main_autofarm_toggle.Value == false then break end

			if LP.Backpack:FindFirstChild("Pan") ~= nil or Character:FindFirstChild("Pan") then
				break
			end

			Character = LP.Character or LP.CharacterAdded:Wait()

			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			RootPart = Character:FindFirstChild("HumanoidRootPart")

			repeat task.wait() until Humanoid ~= nil and RootPart ~= nil
			repeat task.wait() until Humanoid.Health > 0

			for _, v in pairs(workspace.Filter.StuffGiversFolder.PanGiverSpawns:GetChildren()) do
				if v:IsA("MeshPart") and v.Transparency == 0 then

					RootPart.CFrame = v.CFrame

					v.ProximityPrompt.HoldDuration = 0
					v.ProximityPrompt.Enabled = true

					fireproximityprompt(v.ProximityPrompt)
				end
			end
		until LP.Backpack:FindFirstChild("Pan") ~= nil or Character:FindFirstChild("Pan")

		while task.wait() do

			if Options.main_autofarm_toggle.Value == false then break end
			Character = LP.Character or LP.CharacterAdded:Wait()

			Humanoid = Character:FindFirstChildOfClass("Humanoid")
			RootPart = Character:FindFirstChild("HumanoidRootPart")

			repeat task.wait() until Humanoid ~= nil and RootPart ~= nil
			repeat task.wait() until Humanoid.Health > 0

			repeat task.wait() until workspace:FindFirstChild("RakoofNPC") ~= nil and game:GetService("ReplicatedStorage").Values.Day.Value == false
			repeat task.wait() until workspace:FindFirstChild("RakoofNPC"):FindFirstChild("HumanoidRootPart") ~= nil
			
			Options.main_stamina_toggle:SetValue(true)

			RootPart.CFrame = workspace.DeadBlock.CamPartEnd.CFrame
			workspace:FindFirstChild("RakoofNPC").HumanoidRootPart.Anchored = true

			workspace:FindFirstChild("RakoofNPC").HumanoidRootPart.CFrame = RootPart.CFrame + Vector3.new(1, 0, 0)
			workspace:FindFirstChild("RakoofNPC").HumanoidRootPart.Size = Vector3.new(10, 10, 10)

			Humanoid:UnequipTools()

			if LP.Backpack:FindFirstChild("Pan") then
				Humanoid:EquipTool(LP.Backpack:FindFirstChild("Pan"))
			end

			if Character:FindFirstChildOfClass("Tool") then
				Character:FindFirstChildOfClass("Tool"):Activate()
			end
		end
	end))
end
