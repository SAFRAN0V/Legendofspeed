local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local remote = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent")

-- Criar o som de clique futurista
local clickSound = Instance.new("Sound", SoundService)
clickSound.SoundId = "rbxassetid://4499400560"
clickSound.Volume = 0.6
clickSound.Name = "ButtonClickSound"

local function playClickSound()
	clickSound:Play()
end

-- Coordenadas de Teleporte (Tp Jungle)
local targetPosition = Vector3.new(-15269.35, 422.82, 5570.99)

-- Configuração da UI Principal (Estilo Branco com Detalhes Vermelhos - ARASAKA)
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ArasakaPanel_Gui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.5, -120, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(248, 249, 250)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true -- Corta perfeitamente qualquer conteúdo que ultrapasse o arredondamento

local uiCornerMain = Instance.new("UICorner", frame)
uiCornerMain.CornerRadius = UDim.new(0, 10)

local uiStrokeMain = Instance.new("UIStroke", frame)
uiStrokeMain.Color = Color3.fromRGB(215, 50, 50)
uiStrokeMain.Thickness = 1.8

-- Barra de Título (Arredondada e sem preencher as quinas com gambiarras)
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(235, 238, 242)
titleBar.BorderSizePixel = 0

local uiCornerTitle = Instance.new("UICorner", titleBar)
uiCornerTitle.CornerRadius = UDim.new(0, 10)

-- Adesivo Arasaka Logo (ID corrigido e formato assetid completo para garantir carregamento)
local decalImage = Instance.new("ImageLabel", titleBar)
decalImage.Size = UDim2.new(0, 24, 0, 24)
decalImage.Position = UDim2.new(0, 8, 0.5, -12)
decalImage.BackgroundTransparency = 1
decalImage.Image = "rbxassetid://132397224962668"

-- Nome "ARASAKA" Centralizado na Barra de Título
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "ARASAKA"
titleText.TextColor3 = Color3.fromRGB(200, 30, 30)
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14

-- Botão Minimizar (-)
local btnMinimizar = Instance.new("TextButton", titleBar)
btnMinimizar.Size = UDim2.new(0, 30, 0, 30)
btnMinimizar.Position = UDim2.new(1, -34, 0.5, -15)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(250, 230, 230)
btnMinimizar.Text = "-"
btnMinimizar.TextColor3 = Color3.fromRGB(180, 30, 30)
btnMinimizar.Font = Enum.Font.GothamBold
btnMinimizar.TextSize = 16
btnMinimizar.BorderSizePixel = 0
btnMinimizar.ZIndex = 2

local uiCornerMin = Instance.new("UICorner", btnMinimizar)
uiCornerMin.CornerRadius = UDim.new(0, 6)

-- Container para os Elementos Internos
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, 0, 1, -38)
container.Position = UDim2.new(0, 0, 0, 38)
container.BackgroundTransparency = 1

-- Variáveis de Estado
local cidadeSelecionada = "Speed Jungle"
local ativo = false
local minimizado = false

-- Função Auxiliar para Criar Botões Padronizados (Tema Branco com Detalhes Vermelhos)
local function tabularButton(parent, size, pos, text)
	local btn = Instance.new("TextButton", parent)
	btn.Size = size
	btn.Position = pos
	btn.Text = text
	btn.BackgroundColor3 = Color3.fromRGB(238, 241, 245)
	btn.TextColor3 = Color3.fromRGB(45, 50, 58)
	btn.Font = Enum.Font.GothamSemibold
	btn.TextSize = 13
	btn.BorderSizePixel = 0
	
	local corner = Instance.new("UICorner", btn)
	corner.CornerRadius = UDim.new(0, 6)
	
	return btn
end

-- Botões de Seleção de Cidade (Jungle / City)
local btnJungle = tabularButton(container, UDim2.new(0.44, 0, 0, 34), UDim2.new(0.04, 0, 0.05, 0), "Jungle")
local btnCity = tabularButton(container, UDim2.new(0.44, 0, 0, 34), UDim2.new(0.52, 0, 0.05, 0), "City")

-- Destacar a seleção inicial (Jungle selecionado com tom vermelho suave)
btnJungle.BackgroundColor3 = Color3.fromRGB(255, 225, 225)
btnJungle.TextColor3 = Color3.fromRGB(180, 30, 30)

-- Botão Tp Jungle
local btnTpJungle = tabularButton(container, UDim2.new(0.92, 0, 0, 34), UDim2.new(0.04, 0, 0.30, 0), "Tp Jungle")

-- Botão Comprar Pet
local btnPet = tabularButton(container, UDim2.new(0.92, 0, 0, 34), UDim2.new(0.04, 0, 0.55, 0), "Comprar Pet Omega")

-- Botão Principal de Coleta
local btnColeta = tabularButton(container, UDim2.new(0.92, 0, 0, 42), UDim2.new(0.04, 0, 0.80, 0), "INICIAR COLETA")
btnColeta.BackgroundColor3 = Color3.fromRGB(255, 230, 230)
btnColeta.TextColor3 = Color3.fromRGB(180, 30, 30)
btnColeta.Font = Enum.Font.GothamBold

-- Lógica do Botão Minimizar com Animação Limpa
btnMinimizar.MouseButton1Click:Connect(function()
	playClickSound()
	minimizado = not minimizado
	container.Visible = not minimizado
	
	local targetSize = minimizado and UDim2.new(0, 240, 0, 38) or UDim2.new(0, 240, 0, 310)
	btnMinimizar.Text = minimizado and "+" or "-"
	
	TweenService:Create(frame, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = targetSize}):Play()
end)

-- Lógica Anti-AFK
player.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.new())
end)

-- Lógica Botão Tp Jungle
btnTpJungle.MouseButton1Click:Connect(function()
	playClickSound()
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		character.HumanoidRootPart.CFrame = CFrame.new(targetPosition)
	end
end)

-- Lógica Botão Pet
btnPet.MouseButton1Click:Connect(function()
	playClickSound()
	ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", "Electro Legends Crystal")
end)

-- Lógica de Seleção de Cidades
btnJungle.MouseButton1Click:Connect(function()
	playClickSound()
	cidadeSelecionada = "Speed Jungle"
	
	TweenService:Create(btnJungle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 225, 225), TextColor3 = Color3.fromRGB(180, 30, 30)}):Play()
	TweenService:Create(btnCity, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(238, 241, 245), TextColor3 = Color3.fromRGB(45, 50, 58)}):Play()
end)

btnCity.MouseButton1Click:Connect(function()
	playClickSound()
	cidadeSelecionada = "City"
	
	TweenService:Create(btnCity, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 225, 225), TextColor3 = Color3.fromRGB(180, 30, 30)}):Play()
	TweenService:Create(btnJungle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(238, 241, 245), TextColor3 = Color3.fromRGB(45, 50, 58)}):Play()
end)

-- Lógica de Coleta Otimizada
btnColeta.MouseButton1Click:Connect(function()
	playClickSound()
	ativo = not ativo
	
	if ativo then
		btnColeta.Text = "PARAR COLETA"
		TweenService:Create(btnColeta, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(190, 30, 30), TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
		
		task.spawn(function()
			while ativo do
				for i = 1, 7 do
					if not ativo then break end
					remote:FireServer("collectOrb", "Ethereal Orb", cidadeSelecionada)
				end
				task.wait(0.01)
			end
		end)
	else
		btnColeta.Text = "INICIAR COLETA"
		TweenService:Create(btnColeta, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 230, 230), TextColor3 = Color3.fromRGB(180, 30, 30)}):Play()
	end
end)
