local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local cam = workspace.CurrentCamera

local locked = false
local targetPart

UserInputService.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	if input.KeyCode == Enum.KeyCode.E then

		local model
		for _, obj in ipairs(workspace:GetDescendants()) do
			if obj.Name == "FigureRig" and obj:IsA("Model") then
				model = obj
				break
			end
		end
		if not model then return end

		local fakeHead = model:FindFirstChild("FakeHead", true)
		if not fakeHead or not fakeHead:IsA("BasePart") then return end

		if not targetPart then
			targetPart = Instance.new("Part")
			targetPart.Size = Vector3.new(0.05, 0.05, 0.05)
			targetPart.Anchored = false
			targetPart.CanCollide = false
			targetPart.Transparency = 1
			targetPart.Position = fakeHead.Position
			targetPart.Parent = fakeHead

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = fakeHead
			weld.Part1 = targetPart
			weld.Parent = targetPart
		end

		locked = not locked

		if locked then
			cam.CameraType = Enum.CameraType.Scriptable
			RunService:BindToRenderStep("LockCam", Enum.RenderPriority.Camera.Value, function()
				if targetPart then
					-- rotate 90° around Y axis
					cam.CFrame = targetPart.CFrame * CFrame.Angles(0, math.rad(180), 0)
				end
			end)
		else
			RunService:UnbindFromRenderStep("LockCam")
			cam.CameraType = Enum.CameraType.Custom
		end
	end
end)
