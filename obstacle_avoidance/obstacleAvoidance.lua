function driveAsCar(forwardSpeed, angularSpeed)
    -- Equal and opposed components for left and right wheels
    leftSpeed  = forwardSpeed - angularSpeed
    rightSpeed = forwardSpeed + angularSpeed
    robot.wheels.set_velocity(leftSpeed, rightSpeed)
 end
 
 -- Define states
 local states = {
    WALKING = "WALKING",
    AVOIDING_OBSTACLE = "AVOIDING_OBSTACLE"
 }
 
 -- Initial state
 
 
 function init()
    currentState = states.WALKING
    -- Initialization code here
 end
 
 function step()
    if currentState == states.WALKING then
       driveAsCar(robot.random.uniform(5, 15), robot.random.uniform(-5, 5))  -- Walk forward
 
       -- Check proximity sensors for obstacles
       local obstacleDetected = false
       for i = 1, 5 do
          if robot.proximity[i].value ~= 0.0 then
             obstacleDetected = true
             break
          end
       end

       for i = 20, 24 do
        if robot.proximity[i].value ~= 0.0 then
           obstacleDetected = true
           break
        end
     end
 
       -- Transition to obstacle avoidance state if an obstacle is detected
       if obstacleDetected then
          currentState = states.AVOIDING_OBSTACLE
       end
 
    elseif currentState == states.AVOIDING_OBSTACLE then
       driveAsCar(0, 3)  -- Avoid obstacle (adjust angular speed as needed)
 
       -- Check if obstacle is cleared
       local obstacleCleared = true
       for i = 1, 5 do
          if robot.proximity[i].value ~= 0.0 then
             obstacleCleared = false
             break
          end
       end
       for i = 20, 24 do
        if robot.proximity[i].value ~= 0.0 then
           obstacleCleared = false
           break
        end
     end
 
       -- Transition back to walking state if obstacle is cleared
       if obstacleCleared then
          currentState = states.WALKING
       end
    end
 end
 
 function reset()
    -- Reset code here
 end
 
 function destroy()
    -- Destruction code here
 end
 