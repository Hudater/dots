local awful = require('awful')
local gears = require('gears')
local client_keys = require('configuration.client.keys')
local client_buttons = require('configuration.client.buttons')

-- Rules
awful.rules.rules = {
  -- All clients will match this rule.
  -- Add `skip_decoration = true` to other rule_any to exclude that
  {
    rule = {},
    except_any = {
      instance = {
        'nm-connection-editor',
        'file_progress'
      }
    },
    properties = {
      round_corners = true,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      screen = awful.screen.preferred,
      placement = awful.placement.no_offscreen,
      floating = false,
      maximized = false,
      above = false,
      below = false,
      ontop = false,
      sticky = false,
      maximized_horizontal = false,
      maximized_vertical = false  
    }
  },


    -- Dialogs and modals
  {
    rule_any = {
      type = { 'dialog', 'modal' },
      class = {
        'Wicd-client.py',
        'calendar.google.com'
      }
    },
    properties = {
      ontop = true,
      floating = true,
      drawBackdrop = true,
      skip_decoration = true,
      placement = awful.placement.centered
    }
  },


  -- Terminals
  {
    rule_any = {
      class = {
        "URxvt",
        "XTerm",
        "UXTerm",
        "kitty",
        "K3rmit"
       },
    },
    except_any = {
      instance = {
        -- Dont't switch to tag `1` when opening QuakeTerminal
        'QuakeTerminal',
      }
    },
    properties = {
      size_hints_honor = false,
      screen = 1, 
      tag = '1',
      switchtotag = true,
    }
  },

  -- Browsers
  {
    rule_any = {
      class = {
        "firefox",
        "Tor Browser",
        "Brave",
        "Chromium",
      },
    },
    properties = {
      screen = 1,
      tag = '2',
      switchtotag = true,
    }
  },

  -- File Managers
  {
    rule_any = {
       class = {
         "Nemo",
         "File-roller",
         "Dolphin"
       },
    },
    properties = { 
      tag = '3', 
      switchtotag = true,
    }
  },

  -- Editors
  {
    rule_any = {
      class = {
        "gedit",
        "Subl",
      },
    },
    properties = {
      screen = 1,
      tag = '4',
      switchtotag = true,
    }
  },



    -- Multimedia
  {
    rule_any = {
      class = {
        "vlc",
        "spotify",
       },
    },
    properties = {
      screen = 1,
      tag = '7',
      switchtotag = true,
    }
  },

  -- Games
  --[[{
  rule_any = {
    class = {
      "Wine",
      "dolphin-emu",
      "Steam",
      "Citra"
    },
  },
    properties = {
      screen = 1,
      tag = '9',
      switchtotag = true,
      floating = true,
      hide_titlebars = true,
    }
  },--]]

  -- Graphics Editing
  {
  rule_any = {
    class = {
      "joplin-desktop",
      "Gimp-2.10",
      "Inkscape",
      "Flowblade",
      "shotwell",
    },
  },
    properties = {
      screen = 1, 
      tag = '8',
      switchtotag = true,
    }
  },

    -- Workspace Editing and IDEs
  {
  rule_any = {
    class = {
      "Oomox",
      "Unity",
      "UnityHub",
      "jetbrains-studio",
      "Atom",
      "code"
    },
  },
    properties = { 
      screen = 1,
      tag = '5', 
      skip_decoration = true,
      round_corners = true,
      switchtotag = true,
    }
  },




  -- Virtualbox
  --[[{
  rule_any = {
    class = {
      "VirtualBox Manage",
      "VirtualBox Machine"
    },
  },
    properties = { screen = 1, tag = '8'}
  },--]]




  -- Some floating apps
  {
  rule_any = {
    class = {
      "feh",
      "Mugshot",
      "Pulseeffects"
    },
  },
    properties = {
    skip_decoration = true,
    hide_titlebars = true,
    floating = true,
    ontop = true,
    placement = awful.placement.centered
    }
  },


  -- Instances
  -- Network Manager Editor
  {
    rule = {
      instance = 'nm-connection-editor'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  },
  
  -- For nemo progress bar when copying or moving
  {
    rule = {
      instance = 'file_progress'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons,
      placement = awful.placement.centered
    }
  },

  {
    -- For Firefox Popup when you open incognito mode
    rule = {
      instance = 'Popup'
    },
    properties = {
      skip_decoration = true,
      round_corners = true,
      ontop= true,
      floating = true,
      drawBackdrop = false,
      focus = awful.client.focus.filter,
      raise = true,
      keys = client_keys,
      buttons = client_buttons
    }
  }
}


-- Normally we'd do this with a rule but Spotify and SuperTuxKart doesnt set
-- its class or name until is starts up, so we need to catch that signal
client.connect_signal("property::class",function(c)

  if c.class == 'Spotify' or c.class == 'SuperTuxKart' then
    -- Check if already opened
    local app = function(c)
      if c.class == 'SuperTuxKart' then
        return awful.rules.match(c, { class = 'SuperTuxKart' } )
      elseif c.class == 'Spotify' then
        return awful.rules.match(c, { class = 'Spotify' } )
      end
    end

    -- Move it to the desired tag in THIS SCREEN
    local tagName = ''
    if c.class == 'Spotify' then
      tagName = '7'
    elseif c.class == 'SuperTuxKart' then
      tagName = '9'
    end
    local t = awful.tag.find_by_name(awful.screen.focused(), tagName)
    c:move_to_tag(t)
    t:view_only()

    if c.class == 'SuperTuxKart' then
      c.fullscreen = not c.fullscreen
      c:raise()
    end
  end
end)
