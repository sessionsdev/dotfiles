-- RANDOM PLUGIN NOTES
--  lazy = true,
--  event = {
-- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
-- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
--    "BufReadPre /home/sessionsdev/Documents/arca/**.md",
--    "BufNewFile /home/sessionsdev/Documents/arca/**.md",
--  },

local vault_path = vim.fn.getenv("ARCA_PATH")

OBSIDIAN_MODULE = {}

OBSIDIAN_MODULE.opts = function()
    return {
        dir = vault_path, -- no need to call 'vim.fn.expand' here

        open_notes_in = "vsplit",
        use_advanced_uri = true,
        templates = {
            subdir = "template",
            date_format = "%Y-%m-%d %A",
            time_format = "%H:%M",
            -- A map for custom variables, the key should be the variable and the value a function
            substitutions = {}
        },
        daily_notes = {
            -- Optional, if you keep daily notes in a separate directory.
            folder = "journal",
            -- Optional, if you want to change the date format for the ID of daily notes.
            date_format = "%Y/%m/%Y-%m-%d",
            -- Optional, if you want to change the date format of the default alias of daily notes.
            alias_format = nil,
            -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
            template = "template-daily.md"
        },
        -- Optional, completion.
        completion = {
            -- If using nvim-cmp, otherwise set to false
            nvim_cmp = true,
            -- Trigger completion at 2 chars
            min_chars = 2,
            -- Where to put new notes created from completion. Valid options are
            --  * "current_dir" - put new notes in same directory as the current buffer.
            --  * "notes_subdir" - put new notes in the default notes subdirectory.
            new_notes_location = "current_dir",

            -- Whether to add the output of the node_id_func to new notes in autocompletion.
            -- E.g. "[[Foo" completes to "[[foo|Foo]]" assuming "foo" is the ID of the note.
            prepend_note_id = true
        },

        disable_frontmatter = true,
        -- Optional, customize how names/IDs for new notes are created.
        note_id_func = function(title)
            -- Create note IDs in a Zettelkasten format with a timestamp and a suffix.
            -- In this case a note with the title 'My new note' will given an ID that looks
            -- like '1657296016-my-new-note', and therefore the file name '1657296016-my-new-note.md'
            local suffix = ""
            if title ~= nil then
                -- If title is given, transform it into valid file name.
                suffix = title:gsub(" ", "-"):gsub("[^A-Za-z0-9-]", ""):lower()
            else
                -- If title is nil, just add 4 random uppercase letters to the suffix.
                for _ = 1, 4 do
                    suffix = suffix .. string.char(math.random(65, 90))
                end
            end
            return tostring(os.time()) .. "-" .. suffix
        end,

        -- Optional, by default when you use `:ObsidianFollowLink` on a link to an external
        -- URL it will be ignored but you can customize this behavior here.
        follow_url_func = function(url)
            -- Open the URL in the default web browser.
            vim.fn.jobstart({ "open", url }) -- Mac OS
            --  vim.fn.jobstart({ "xdg-open", url }) -- linux
        end,
    }
end

return OBSIDIAN_MODULE
