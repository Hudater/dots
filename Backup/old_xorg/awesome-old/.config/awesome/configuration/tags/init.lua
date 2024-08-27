local awful = require('awful')
local gears = require('gears')
local icons = require('theme.icons')

local tags = {
  {
    icon = icons.terminal,
    type = 'terminal',
    defaultApp = 'kitty',
    screen = 1
  },
  {
    icon = icons.chrome,
    type = 'chrome',
    defaultApp = 'chromium',
    screen = 1
  },
  {
    icon = icons.folder,
    type = 'files',
    defaultApp = 'nemo',
    screen = 1
  },
  {
    icon = icons.code,
    type = 'code',
    defaultApp = 'subl',
    screen = 1
  },
  {
    icon = icons.game,
    type = 'game',
    defaultApp = 'code',
    screen = 1
  },
  {
    icon = icons.social,
    type = 'social',
    defaultApp = 'discord',
    screen = 1
  },

  {
    icon = icons.music,
    type = 'music',
    defaultApp = 'spotify',
    screen = 1
  },
  {
    icon = icons.art,
    type = 'art',
    defaultApp = 'joplin-desktop',
    screen = 1
  },
  {
    icon = icons.lab,
    type = 'any',
    defaultApp = '',
    screen = 1
  }
  --[[{
    icon = icons.vbox,
    type = 'virtualbox',
    defaultApp = 'virtualbox',
    screen = 1
  },--]]

}

awful.layout.layouts = {
  --awful.layout.suit.spiral.dwindle,
  awful.layout.suit.tile,
  awful.layout.suit.max
}


screen.connect_signal("request::desktop_decoration", function(s)
  for i, tag in pairs(tags) do
    awful.tag.add(
      i,
      {
        icon = tag.icon,
        icon_only = true,
        layout = awful.layout.suit.max,
        gap_single_client = false,
        gap = 4,
        screen = s,
        defaultApp = tag.defaultApp,
        selected = i == 1
      }
    )
  end
end)


_G.tag.connect_signal(
  'property::layout',
  function(t)
    local currentLayout = awful.tag.getproperty(t, 'layout')
    if (currentLayout == awful.layout.suit.max) then
      t.gap = 0
    else
      t.gap = 4
    end
  end
)
