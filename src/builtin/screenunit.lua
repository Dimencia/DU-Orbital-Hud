ScreenUnit = require('src.builtin.element')

-- Display the given text at a the given coordinates on the screen, and return an id to move it later
function ScreenUnit.addText(x, y, fontSize, text)
end

-- Displays the given tet centered in the screen with a font to maximize its visibility
function ScreenUnit.setCenteredText(text)
end

-- Set the whole screen HTML content.
function ScreenUnit.setHTML(html)
end

-- Display the given HTML content at the given coordinates, and return an id to move it later
function ScreenUnit.addContent(x, y, html)
end

-- Displays SVG code which overrides pre-existing content.
function ScreenUnit.setSVG(svg)
end

-- Update the eleemnt with the given ID (returned by setContent) with a new HTML content
function ScreenUnit.resetContent(id, html)
end

-- Delete the element with the given ID (returned by setContent)
function ScreenUnit.deleteContent(id)
end

-- Update the visibility of the element with the given ID (returned by setContent)
function ScreenUnit.showContent(id, state)
end

-- Move the eleemnt with the given ID (returned by setContent) to a new position on the screen
function ScreenUnit.moveContent(id, x, y)
end

-- Returns the x-coordinate of the positiion pointed at in the screen
function ScreenUnit.getMouseX()
end

-- Returns the y-coordinate of the position pointed at in the screen.
function ScreenUnit.getMouseY()
end

-- Returns the state of mouse click
function ScreenUnit.getMouseState()
end

-- Clear the screen
function ScreenUnit.clear()
end

return ScreenUnit
