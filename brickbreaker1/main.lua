
require ("physics")

function main()

	setUpPhysics()
	createWalls()
	createBricks()
	createBall()
	createPaddle()
	startGame()

end

function setUpPhysics()
	physics.start()
	-- physics.setDrawMode("hybrid")
	physics.setGravity(0,.1)
end


function createPaddle()
	
	local paddleWidth = 110
	local paddleHeight = 15
	
	local paddle = display.newRect( display.contentWidth / 2 - paddleWidth / 2, display.contentHeight - 50, paddleWidth, paddleHeight )
	physics.addBody(paddle, "static", {friction=0, bounce=1})

	local  movePaddle = function(event)
			paddle.x = event.x
	end

	Runtime:addEventListener("touch", movePaddle)
	
end


function createBall()

	local ballRadius = 12

	ball = display.newCircle( display.contentWidth / 2, display.contentHeight / 2, ballRadius )
	physics.addBody(ball, "dynamic", {friction=0, bounce = 1, radius=ballRadius})

	ball.collision = function(self, event)
		if(event.phase == "ended") then
			
			if(event.other.type == "destructible") then
				event.other:removeSelf()
			end
			
			if(event.other.type == "bottomWall") then
			
				self:removeSelf()
				
				local onTimerComplete = function(event)
					createBall()
					startGame()
				end
				
				timer.performWithDelay(500, onTimerComplete , 1)
			end
		end
	end

	ball:addEventListener("collision", ball)
end

function startGame()
	ball:setLinearVelocity(75, 150)	
end


function createBricks()
	
	local brickWidth = 40
	local brickHeight = 25
		
	local numOfRows = 5
	local numOfCols = 6
	
	local topLeft = {x= display.contentWidth / 2 - (brickWidth * numOfCols ) / 2, y= 50}
	
	local row
	local col
	
	for row = 0, numOfRows - 1 do
		for col = 0, numOfCols - 1 do
		
			-- Create a brick
			local brick = display.newRect( topLeft.x + (col * brickWidth), topLeft.y + (row * brickHeight), brickWidth, brickHeight )
			brick:setFillColor(math.random(50, 255), math.random(50, 255), math.random(50, 255), 255)
			brick.type = "destructible"
			
			physics.addBody(brick, "static", {friction=0, bounce = 1})
		end
	end
end


function createWalls()
	
	local wallThickness = 10
	
	-- Left wall
	local wall = display.newRect( 0, 0, wallThickness, display.contentHeight )
	physics.addBody(wall, "static", {friction=0, bounce = 1})
	
	-- Top wall
	wall = display.newRect(0,0, display.contentWidth, wallThickness)
	physics.addBody(wall, "static", {friction=0, bounce = 1})
	
	-- Right wall
	wall = display.newRect(display.contentWidth - wallThickness, 0, wallThickness, display.contentHeight)
	physics.addBody(wall, "static", {friction=0, bounce = 1})
	
	-- Bottom wall
	wall = display.newRect(0, display.contentHeight - wallThickness, display.contentWidth, wallThickness)
	physics.addBody(wall, "static", {friction=.2, bounce = 1})
	
	wall.type = "bottomWall"
end


main()