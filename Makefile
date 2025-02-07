push:
	git commit -m "$(msg)"
	git push origin main

reset:
	git reset --hard