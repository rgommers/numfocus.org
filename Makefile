PY=python
PELICAN=pelican
PELICANOPTS=

BASEDIR=$(CURDIR)
INPUTDIR=$(BASEDIR)/content
OUTPUTDIR=$(BASEDIR)/output
CONFFILE=$(BASEDIR)/pelicanconf.py
PUBLISHCONF=$(BASEDIR)/publishconf.py

FTP_HOST=localhost
FTP_USER=anonymous
FTP_TARGET_DIR=/

SSH_HOST=localhost
SSH_PORT=22
SSH_USER=root
SSH_TARGET_DIR=/var/www

TOP_LEVEL_DOMAIN?=numfocus.org

S3_BUCKET=my_s3_bucket

DROPBOX_DIR=~/Dropbox/Public/

# The github remote that the main website is hosted from
GITHUB_DEPLOY_REMOTE?=upstream

# The remote you'd like to push to
GITHUB_REMOTE?=$(GITHUB_DEPLOY_REMOTE)

# The github pages branch, should be either gh-pages or master
GITHUB_PAGES_BRANCH?=gh-pages

help:
	@echo 'Makefile for a pelican Web site                                        '
	@echo '                                                                       '
	@echo 'Usage:                                                                 '
	@echo '   make html                        (re)generate the web site          '
	@echo '   make debug                       (re)generate the web site with debug mode'
	@echo '   make theme                       compile css in theme (called by html)'
	@echo '   make clean                       remove the generated files         '
	@echo '   make regenerate                  regenerate files upon modification '
	@echo '   make publish                     generate using production settings '
	@echo '   make serve                       serve site at http://localhost:8000'
	@echo '   make devserver                   start/restart develop_server.sh    '
	@echo '   make stopserver                  stop local server                  '
	@echo '   make ssh_upload                  upload the web site via SSH        '
	@echo '   make rsync_upload                upload the web site via rsync+ssh  '
	@echo '   make dropbox_upload              upload the web site via Dropbox    '
	@echo '   make ftp_upload                  upload the web site via FTP        '
	@echo '   make s3_upload                   upload the web site via S3         '
	@echo '   make github                      upload the web site via gh-pages   '
	@echo '                                                                       '


html: clean theme $(OUTPUTDIR)/index.html

debug: clean theme 
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS) --verbose --debug
	
theme:
	cd theme && $(MAKE) 

$(OUTPUTDIR)/%.html:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	cp -nr redirects/* $(OUTPUTDIR) || true

clean:
	$(MAKE) -C theme clean
	[ ! -d $(OUTPUTDIR) ] || find $(OUTPUTDIR) -mindepth 1 -delete

regenerate: clean
	$(PELICAN) -r $(INPUTDIR) -o $(OUTPUTDIR) -s $(CONFFILE) $(PELICANOPTS)
	cp -nr redirects/* $(OUTPUTDIR) || true

serve:
	cd $(OUTPUTDIR) && $(PY) -m pelican.server

devserver:
	$(BASEDIR)/develop_server.sh restart

stopserver:
	kill -9 `cat pelican.pid` || true
	kill -9 `cat srv.pid` || true
	@echo 'Stopped Pelican and SimpleHTTPServer processes running in background.'
	$(RM) -rf pelican.pid srv.pid

publish:
	$(PELICAN) $(INPUTDIR) -o $(OUTPUTDIR) -s $(PUBLISHCONF) $(PELICANOPTS)
	cp -nr redirects/* $(OUTPUTDIR) || true

ssh_upload: publish
	scp -P $(SSH_PORT) -r $(OUTPUTDIR)/* $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR)

rsync_upload: publish
	rsync -e "ssh -p $(SSH_PORT)" -P -rvz --delete $(OUTPUTDIR)/ $(SSH_USER)@$(SSH_HOST):$(SSH_TARGET_DIR) --cvs-exclude

dropbox_upload: publish
	cp -r $(OUTPUTDIR)/* $(DROPBOX_DIR)

ftp_upload: publish
	lftp ftp://$(FTP_USER)@$(FTP_HOST) -e "mirror -R $(OUTPUTDIR) $(FTP_TARGET_DIR) ; quit"

s3_upload: publish
	s3cmd sync $(OUTPUTDIR)/ s3://$(S3_BUCKET) --acl-public --delete-removed

github: publish
	test "$(GITHUB_REMOTE)" = "$(GITHUB_DEPLOY_REMOTE)" && (echo "$(TOP_LEVEL_DOMAIN)" > $(OUTPUTDIR)/CNAME) || echo "CNAME file not made, GITHUB_REMOTE != GITHUB_DEPLOY_REMOTE"
	ghp-import $(OUTPUTDIR) 
	git push -f $(GITHUB_REMOTE) $(GITHUB_PAGES_BRANCH) 

.PHONY: html debug theme help clean regenerate serve devserver publish ssh_upload rsync_upload dropbox_upload ftp_upload s3_upload github
