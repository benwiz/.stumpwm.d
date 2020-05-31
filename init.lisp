(in-package :stumpwm)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4005
                     :style swank:*communication-style*
                     :dont-close t)

;; TODO dump frames on quit and load on start, maybe ask in both cases or auto do it after 20 seconds
;; TODO run-or-raise-or-pull fn
;; - find window by class (maybe use echo-windows but probably not)
;; - check if window is visible using `window-visible-p`
;; - if visible, raise. Else, pull.
;; TODO raise-or-pull-from-windowlist

;; TODO figure out how groups work

;; -----------------------------------------------------------
;; Installations

;; (ql:quickload "swank")
;; (ql:quickload "clx")
;; (ql:quickload "cl-ppcre")
;; (ql:quickload "alexandria")
;; (ql:quickload "xembed") ;; for stumptray
;; (ql:quickload "quicklisp-slime-helper")

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules
;; sudo apt install -y dmenu

;; git clone git@github.com:l04m33/clx-truetype.git
;; (ql:quickload "clx-truetype")
;; (clx-truetype:cache-fonts)

;; ------------------------------------------------------------
;; Key Bindings

(define-key *root-map* (kbd "0") "remove")
(define-key *root-map* (kbd "1") "only")
(define-key *root-map* (kbd "2") "vsplit")
(define-key *root-map* (kbd "3") "hsplit")

(define-key *root-map* (kbd "e") "emacs")
(define-key *root-map* (kbd "E") "exec emacs")
(define-key *root-map* (kbd "i") "firefox")
(define-key *root-map* (kbd "I") "exec firefox")
(define-key *root-map* (kbd "u") "mode-line")
(define-key *root-map* (kbd "b") "pull-from-windowlist")
(define-key *root-map* (kbd "C-b") "pull-from-windowlist")
(define-key *root-map* (kbd "b") "pull-from-windowlist")
(define-key *root-map* (kbd "c") "term")
(define-key *root-map* (kbd "C-c") "term")
(define-key *root-map* (kbd "\C") "exec gnome-terminal")
(define-key *root-map* (kbd "F10") "gtk-theme")
(define-key *root-map* (kbd "F12") "end-session")

(define-key *top-map* (kbd "M-`") "show-menu")
(define-key *top-map* (kbd "M-SPC") "dmenu")

;; ------------------------------------------------------------
;; Other configs

;; Mouse
(setf *mouse-focus-policy* :click)

;; Message Box
(setf *message-window-gravity* :center)
(setf *input-window-gravity* :center)
(set-bg-color "#111111")
(set-fg-color "#00EEEE")
(set-border-color "#005555")
(setf *message-window-padding* 16)
(setf *message-window-y-padding* 50) ;; FIXME this isn't working. Would like to set to *message-window-padding*

;; -----------------------------------------------------------
;; Modeline

;; (load-module "battery-portable")
;; (load-module "cpu")
;; (load-module "mem")
;; (load-module "wifi")
;; (load-module "stumptray")
;; (stumptray::stumptray)

;; Format
(setf *screen-mode-line-format* (list "%v"
                                      "^>"
                                      ;; "%C"
                                      ;; "%M"
                                      ;; "%I"
                                      ;; "%B"
                                      "%d"))
(setf *mode-line-border-width* 0)
(setf *mode-line-background-color* "#101010")
(setf *mode-line-foreground-color* "#00A0A0")
(setf *mode-line-timeout* 10)
(setf *hidden-window-color* "^7")
(setf *window-format* " (%n) %16c")


;; Enable
(enable-mode-line (current-screen) (current-head) t)

;; Toggle
(defcommand mode-line () ()
  (toggle-mode-line (current-screen) (current-head)))

;; ------------------------------------------------------------
;; Custom commands for built-in or cli tooling (not modules)

(defcommand editrc () ()
  "edit this file"
  (run-shell-command "emacs ~/.stumpwmrc"))

(defcommand dmenu () ()
  "run dmenu"
  (run-shell-command "dmenu_run"))

(defcommand emacs () ()
  "run emacs"
  (run-or-pull "emacs" '(:class "Emacs")))

(defcommand term () ()
  "run gnome-terminal"
  (run-or-pull "gnome-terminal" '(:class "Gnome-terminal")))

(defcommand firefox () ()
  "run firefox"
  (run-or-pull "firefox" '(:class "Firefox")))

(defcommand spotify () ()
  "run spotify"
  (run-or-pull "spotify" '(:class "Spotify")))

(defcommand frescobaldi () ()
  "run frescobaldi"
  (run-or-pull "frescobaldi" '(:class "Frescobaldi")))

(defcommand gtk-theme () ()
  "toggle theme between dark and light"
  (if (string= (run-shell-command "gsettings get org.gnome.desktop.interface gtk-theme" t)
               "'Adwaita-dark'
") ;; yes, this new line is necessary
      (run-shell-command "gsettings set org.gnome.desktop.interface gtk-theme Adwaita")
      (run-shell-command "gsettings set org.gnome.desktop.interface gtk-theme Adwaita-dark")))

;; ------------------------------------------------------------
;; Modules
(add-to-load-path "/home/benwiz/.stumpwm.d/modules")

;; Fonts
;; (load-module "ttf-fonts") ;; idk why load-module didn't work
(asdf:make "ttf-fonts")
(set-font (make-instance 'xft:font
                         :family "DejaVu Sans Mono"
                         :subfamily "Book"
                         :size 14))

;; App Menu
(load-module "app-menu")

(setq app-menu:*app-menu* ;; Can create submenus but I don't think I need it
      '(("Firefox" firefox)
        ("Spotify" spotify)
        ("Frescobaldi" frescobaldi)
        ))

;; End Session
(load-module "end-session")
