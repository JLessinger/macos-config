os.execute('rm /usr/local/bin/hs')
os.execute('rm /usr/local/share/man/man1/hs.1')
ipc = require('hs.ipc')
ipc.cliInstall()

-- remap_l_up = hs.hotkey.bind({'cmd'}, 'l', function() hs.eventtap.keyStroke({'cmd'}, 'up') end)
-- f_real_l = hs.hotkey.bind({'ctrl'}, 'f', function() remap_l_up:disable(); hs.eventtap.keyStroke({'cmd'}, 'l'); remap_l_up:enable() end)