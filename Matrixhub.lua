-- Servicios necesarios
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Crear la Interfaz Gráfica (MatrixHub)
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MatrixHub"
screenGui.Parent = player:WaitForChild("PlayerGui")

-- Marco principal (Ventana)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 200)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 15, 0) -- Verde muy oscuro / casi negro
mainFrame.BorderColor3 = Color3.fromRGB(0, 255, 0) -- Borde verde Matrix
mainFrame.BorderSizePixel = 2
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Título del Menú
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(0, 30, 0)
titleLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
titleLabel.Text = "MATRIX HUB"
titleLabel.TextSize = 18
titleLabel.Font = Enum.Font.Code
titleLabel.Parent = mainFrame

-- Botón de Volar
local flyButton = Instance.new("TextButton")
flyButton.Size = UDim2.new(0.8, 0, 0, 50)
flyButton.Position = UDim2.new(0.1, 0, 0.4, 0)
flyButton.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
flyButton.BorderColor3 = Color3.fromRGB(0, 255, 0)
flyButton.TextColor3 = Color3.fromRGB(0, 255, 0)
flyButton.Text = "Volar Modo Admin: OFF"
flyButton.TextSize = 14
flyButton.Font = Enum.Font.Code
flyButton.Parent = mainFrame

-- Lógica de Vuelo
local flying = false
local flySpeed = 50
local bodyVelocity, bodyGyro

local function toggleFly()
	flying = not flying
	
	local char = player.Character
	if not char then return end
	local rootPart = char:FindFirstChild("HumanoidRootPart")
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	
	if flying then
		flyButton.Text = "Volar Modo Admin: ON"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
		
		if rootPart then
			bodyVelocity = Instance.new("BodyVelocity")
			bodyVelocity.Velocity = Vector3.new(0, 0, 0)
			bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
			bodyVelocity.Parent = rootPart
			
			bodyGyro = Instance.new("BodyGyro")
			bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
			bodyGyro.CFrame = rootPart.CFrame
			bodyGyro.Parent = rootPart
			
			if humanoid then
				humanoid.PlatformStand = true
			end
		end
	else
		flyButton.Text = "Volar Modo Admin: OFF"
		flyButton.BackgroundColor3 = Color3.fromRGB(0, 40, 0)
		
		if bodyVelocity then bodyVelocity:Destroy() end
		if bodyGyro then bodyGyro:Destroy() end
		
		if humanoid then
			humanoid.PlatformStand = false
		end
	end
end

flyButton.MouseButton1Click:Connect(toggleFly)

-- Bucle de movimiento para el vuelo
RunService.RenderStepped:Connect(function()
	if flying and character and character:FindFirstChild("HumanoidRootPart") then
		local rootPart = character.HumanoidRootPart
		local camera = workspace.CurrentCamera
		
		local moveDirection = Vector3.new(0, 0, 0)
		
		if UserInputService:IsKeyDown(Enum.KeyCode.W) then
			moveDirection = moveDirection + camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.S) then
			moveDirection = moveDirection - camera.CFrame.LookVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.A) then
			moveDirection = moveDirection - camera.CFrame.RightVector
		end
		if UserInputService:IsKeyDown(Enum.KeyCode.D) then
			moveDirection = moveDirection + camera.CFrame.RightVector
		end
		
		if bodyVelocity and bodyGyro then
			bodyVelocity.Velocity = moveDirection * flySpeed
			bodyGyro.CFrame = camera.CFrame
		end
	end
end)
