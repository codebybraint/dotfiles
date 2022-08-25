# braint's Personal dotfiles

this dotfiles contain : 
1. neovim dotfiles. ( .config/nvim/ )
2. tmux.conf

## 1. NVIM
### Check health for neovim
Open neovim, then enter the following command
( even nvim already healthy, that doesn't mean other plugin is healthy )

```
:checkhealth nvim
```
don't forget to check all the active plugin, some plugin may already deprecated

Optional, check this following packages :

1. Telescope ( on my case, php return an error ) 
2. Mason ( checkhealth, this one require npm and node to some extent )
notes : Debian distro often use older verision of package, make sure it's latest, or at least work well with the one we need

### Java Development 

1. Install jdtls ( Add jdtls to mason config file )
2. Check java version before use java-debug ( Idk, but the java 8: java-se-8u42-ri, already checked and work for this java-debug)
3. Download java debugger, add it inside nvim folder

```
( use java-se-8u42-ri on this command)

git clone git@github.com:microsoft/java-debug.git
cd java-debug/
./mvnw clean install
```

4. Download VSCode Java Test

```
(check npm first before run this)
git clone git@github.com:microsoft/vscode-java-test.git
cd vscode-java-test
npm install
npm run build-plugin
```

Optional, null-ls : isntall google_java_format

## Next thing TODO:
2. i3
