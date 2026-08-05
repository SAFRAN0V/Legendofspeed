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

-- Configuração da UI Principal (Estilo Branco Clean / Minimalista)
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "PainelSH_Gui"
screenGui.ResetOnSpawn = false

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 240, 0, 310)
frame.Position = UDim2.new(0.5, -120, 0.5, -155)
frame.BackgroundColor3 = Color3.fromRGB(248, 249, 250)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local uiCornerMain = Instance.new("UICorner", frame)
uiCornerMain.CornerRadius = UDim.new(0, 10)

local uiStrokeMain = Instance.new("UIStroke", frame)
uiStrokeMain.Color = Color3.fromRGB(218, 222, 225)
uiStrokeMain.Thickness = 1.5

-- Barra de Título
local titleBar = Instance.new("Frame", frame)
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(235, 238, 242)
titleBar.BorderSizePixel = 0

local uiCornerTitle = Instance.new("UICorner", titleBar)
uiCornerTitle.CornerRadius = UDim.new(0, 10)

-- Correção visual para os cantos inferiores da barra de título ficarem retos
local fixTitleCorner = Instance.new("Frame", titleBar)
fixTitleCorner.Size = UDim2.new(1, 0, 0, 10)
fixTitleCorner.Position = UDim2.new(0, 0, 1, -10)
fixTitleCorner.BackgroundColor3 = Color3.fromRGB(235, 238, 242)
fixTitleCorner.BorderSizePixel = 0

-- Adesivo (Red Eyes - rbxassetid://135049032413283) à esquerda
local decalImage = Instance.new("ImageLabel", titleBar)
decalImage.Size = UDim2.new(0, 24, 0, 24)
decalImage.Position = UDim2.new(0, 8, 0.5, -12)
decalImage.BackgroundTransparency = 1
decalImage.Image = "rbxassetid://135049032413283"

-- Nome "Painel SH" Centralizado na Barra de Título
local titleText = Instance.new("TextLabel", titleBar)
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Painel SH"
titleText.TextColor3 = Color3.fromRGB(30, 35, 42)
titleText.TextXAlignment = Enum.TextXAlignment.Center
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 14

-- Botão Minimizar (-)
local btnMinimizar = Instance.new("TextButton", titleBar)
btnMinimizar.Size = UDim2.new(0, 30, 0, 30)
btnMinimizar.Position = UDim2.new(1, -34, 0.5, -15)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(220, 224, 230)
btnMinimizar.Text = "-"
btnMinimizar.TextColor3 = Color3.fromRGB(40, 45, 52)
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

-- Função Auxiliar para Criar Botões Padronizados (Tema Branco)
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

-- Destacar a seleção inicial (Jungle selecionado)
btnJungle.BackgroundColor3 = Color3.fromRGB(210, 215, 225)
btnJungle.TextColor3 = Color3.fromRGB(15, 20, 28)

-- Botão Tp Jungle
local btnTpJungle = tabularButton(container, UDim2.new(0.92, 0, 0, 34), UDim2.new(0.04, 0, 0.30, 0), "Tp Jungle")

-- Botão Comprar Pet
local btnPet = tabularButton(container, UDim2.new(0.92, 0, 0, 34), UDim2.new(0.04, 0, 0.55, 0), "Comprar Pet Omega")

-- Botão Principal de Coleta
local btnColeta = tabularButton(container, UDim2.new(0.92, 0, 0, 42), UDim2.new(0.04, 0, 0.80, 0), "INICIAR COLETA")
btnColeta.BackgroundColor3 = Color3.fromRGB(220, 245, 225) -- Verde claro suave
btnColeta.TextColor3 = Color3.fromRGB(20, 90, 45)
btnColeta.Font = Enum.Font.GothamBold

-- Lógica do Botão Minimizar com Animação Suave
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
	
	TweenService:Create(btnJungle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(210, 215, 225), TextColor3 = Color3.fromRGB(15, 20, 28)}):Play()
	TweenService:Create(btnCity, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(238, 241, 245), TextColor3 = Color3.fromRGB(45, 50, 58)}):Play()
end)

btnCity.MouseButton1Click:Connect(function()
	playClickSound()
	cidadeSelecionada = "City"
	
	TweenService:Create(btnCity, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(210, 215, 225), TextColor3 = Color3.fromRGB(15, 20, 28)}):Play()
	TweenService:Create(btnJungle, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(238, 241, 245), TextColor3 = Color3.fromRGB(45, 50, 58)}):Play()
end)

-- Lógica de Coleta Otimizada
btnColeta.MouseButton1Click:Connect(function()
	playClickSound()
	ativo = not ativo
	
	if ativo then
		btnColeta.Text = "PARAR COLETA"
		TweenService:Create(btnColeta, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 220, 220), TextColor3 = Color3.fromRGB(120, 25, 25)}):Play() -- Vermelho claro suave
		
		task.spawn(function()
			while ativo do
				for i = 1, 10 do
					if not ativo then break end
					remote:FireServer("collectOrb", "Ethereal Orb", cidadeSelecionada)
				end
				task.wait(0.01)
			end
		end)
	else
		btnColeta.Text = "INICIAR COLETA"
		TweenService:Create(btnColeta, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(220, 245, 225), TextColor3 = Color3.fromRGB(20, 90, 45)}):Play()
	end
end)
