(in-package :stumpwm)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4005
                     :style swank:*communication-style*
                     :dont-close t)

;; TODO fonts (check modules ttf-fonts)
;; TODO fuzzy finder for open windows
;; TODO fuzzy finder for applications similar to counsel-linux-app

;; -----------------------------------------------------------
;; General Packages and other things I have run

;; (ql:quickload "clx")
;; (ql:quickload "cl-ppcre")
;; (ql:quickload "alexandria")

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules

;; desktop-entry
;; (ql:quickload :py-configparser)
;; (ql:quickload :FiveAM)

;; ------------------------------------------------------------
;; Key Bindings

(define-key *root-map* (kbd "i") "firefox") ;; run or raise
(define-key *root-map* (kbd "I") "exec firefox") ;; run
(define-key *root-map* (kbd "u") "mode-line")

(define-key *top-map* (kbd "M-`") "show-menu")
(define-key *top-map* (kbd "M-SPC") "dmenu")

;; ------------------------------------------------------------
;; Other configs

;; Mouse
(setf *mouse-focus-policy* :click)

;; Message Box
(setf *message-window-gravity* :top-right)
(setf *input-window-gravity* :center)

;; Modeline (not yet convinced of its value)
(enable-mode-line (current-screen) (current-head) t)
(setf *screen-mode-line-format* (list "%d" " | " "%v"))
(defcommand mode-line () ()
  (toggle-mode-line (current-screen) (current-head)))

;; TODO fonts

;; ------------------------------------------------------------
;; Custom commands

;; Edit this file
(defcommand editrc () ()
  (run-shell-command "emacs ~/.stumpwmrc"))

;; demnu
;; TODO I can probably build a menu https://stumpwm.github.io/git/stumpwm-git_13.html#Menus-2
(defcommand dmenu () ()
  (run-shell-command "dmenu_run"))

;; ------------------------------------------------------------
;; Modules
(add-to-load-path "/home/benwiz/.stumpwm.d/modules")

;; App Menu
(load-module "app-menu")

(defcommand firefox () ()
  "run firefox"
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand spotify () ()
  "run spotify"
  (run-or-raise "spotify" '(:class "Spotify")))

(defcommand frescobaldi () ()
  "run frescobaldi"
  (run-or-raise "frescobaldi" '(:class "Frescobaldi")))

(setq app-menu:*app-menu* ;; Can create submenus but I don't think I need it
      '(("Firefox" firefox)
        ("Spotify" spotify)
        ("Frescobaldi" frescobaldi)
        ))

;; Desktop Entry
;; TODO add ability to (fuzzy) search and submit pull request
(load-module "desktop-entry")
(desktop-entry:init-entry-list)

;; End Session
(load-module "end-session")
