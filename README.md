Using multiple SSH keys with github

**example ~/.ssh/config**

```
Host github.com-work
	hostname github.com
	user git
	identityfile ~/.ssh/work-key

Host github.com-personal
	hostname github.com
	user git
	identityfile ~/.ssh/personal-key

```
**Personal**

`git remote set-url origin git@github.com-personal:personal-account-org-name/project-name.git`

`git push -u origin`

**Work**

`git remote set-url origin git@github.com-work:work-account-org-name/project-name.git`

`git push -u origin`