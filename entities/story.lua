local Story = {}

function Story:new(waves, acts)
    return {
        story = { waves = waves, acts = acts }
    }
end

return Story