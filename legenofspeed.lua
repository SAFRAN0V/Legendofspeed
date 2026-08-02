local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local remote = ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("orbEvent")

-- Configuração da UI Principal
local screenGui = Instance.new("ScreenGui", game.Players.LocalPlayer:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 200)
frame.Position = UDim2.new(0.5, -110, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.Active = true
frame.Draggable = true

-- Barra de Título
local titleBar = Instance.new("TextLabel", frame)
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
titleBar.Text = "  Painel de Farm"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.TextXAlignment = Enum.TextXAlignment.Left
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 14

-- Botão Minimizar (-)
local btnMinimizar = Instance.new("TextButton", titleBar)
btnMinimizar.Size = UDim2.new(0, 30, 0, 30)
btnMinimizar.Position = UDim2.new(1, -30, 0, 0)
btnMinimizar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
btnMinimizar.Text = "-"
btnMinimizar.TextColor3 = Color3.fromRGB(255, 255, 255)
btnMinimizar.Font = Enum.Font.SourceSansBold
btnMinimizar.TextSize = 16

-- Container para os botões
local container = Instance.new("Frame", frame)
container.Size = UDim2.new(1, 0, 1, -30)
container.Position = UDim2.new(0, 0, 0, 30)
container.BackgroundTransparency = 1

-- Variáveis de Estado
local cidadeSelecionada = "Speed Jungle"
local ativo = false
local minimizado = false

-- Botão Jungle
local btnJungle = Instance.new("TextButton", container)
btnJungle.Size = UDim2.new(0.43, 0, 0, 30); btnJungle.Position = UDim2.new(0.05, 0, 0.05, 0)
btnJungle.Text = "Jungle"
btnJungle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)

-- Botão City
local btnCity = Instance.new("TextButton", container)
btnCity.Size = UDim2.new(0.43, 0, 0, 30); btnCity.Position = UDim2.new(0.52, 0, 0.05, 0)
btnCity.Text = "City"
btnCity.BackgroundColor3 = Color3.fromRGB(100, 100, 100)

-- Botão Comprar Pet
local btnPet = Instance.new("TextButton", container)
btnPet.Size = UDim2.new(0.9, 0, 0, 30); btnPet.Position = UDim2.new(0.05, 0, 0.40, 0)
btnPet.Text = "Comprar Pet Omega"
btnPet.BackgroundColor3 = Color3.fromRGB(150, 0, 150)

-- Botão Coleta
local btnColeta = Instance.new("TextButton", container)
btnColeta.Size = UDim2.new(0.9, 0, 0, 30); btnColeta.Position = UDim2.new(0.05, 0, 0.70, 0)
btnColeta.Text = "INICIAR COLETA"
btnColeta.BackgroundColor3 = Color3.fromRGB(0, 200, 0)

-- Lógica do Botão Minimizar
btnMinimizar.MouseButton1Click:Connect(function()
    minimizado = not minimizado
    container.Visible = not minimizado
    if minimizado then
        frame.Size = UDim2.new(0, 220, 0, 30)
        btnMinimizar.Text = "+"
    else
        frame.Size = UDim2.new(0, 220, 0, 200)
        btnMinimizar.Text = "-"
    end
end)

-- Lógica Anti-AFK
game.Players.LocalPlayer.Idled:Connect(function()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton2(Vector2.new())
end)

-- Lógica Botão Pet
btnPet.MouseButton1Click:Connect(function()
    ReplicatedStorage:WaitForChild("rEvents"):WaitForChild("openCrystalRemote"):InvokeServer("openCrystal", "Electro Legends Crystal")
end)

-- Lógica de Seleção
btnJungle.MouseButton1Click:Connect(function()
    cidadeSelecionada = "Speed Jungle"
    btnJungle.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    btnCity.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

btnCity.MouseButton1Click:Connect(function()
    cidadeSelecionada = "City"
    btnCity.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
    btnJungle.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
end)

-- Lógica de Coleta Otimizada (Sem travar o buffer e com parada instantânea)
btnColeta.MouseButton1Click:Connect(function()
    ativo = not ativo
    btnColeta.Text = ativo and "PARAR" or "INICIAR COLETA"
    btnColeta.BackgroundColor3 = ativo and Color3.fromRGB(200, 0, 0) or Color3.fromRGB(0, 200, 0)
    
    if ativo then
        task.spawn(function()
            while ativo do
                for i = 1, 12 do
                    if not ativo then break end
                    remote:FireServer("collectOrb", "Ethereal Orb", cidadeSelecionada)
                end
                task.wait(0.01) -- Pequeno respiro para o servidor processar limpo
            end
        end)
    end
end)
