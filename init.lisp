(in-package :stumpwm)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4005
                     :style swank:*communication-style*
                     :dont-close t)

;; TODO dump frames on quit and load on start, maybe ask in both cases or auto do it after 20 seconds

;; -----------------------------------------------------------
;; Installations

;; (ql:quickload "swank")
;; (ql:quickload "clx")
;; (ql:quickload "cl-ppcre")
;; (ql:quickload "alexandria")
;; (ql:quickload "xembed") ;; for stumptray

;; git clone https://github.com/stumpwm/stumpwm-contrib ~/.stumpwm.d/modules
;; sudo apt install -y dmenu

;; ------------------------------------------------------------
;; Key Bindings

(define-key *root-map* (kbd "i") "firefox")
(define-key *root-map* (kbd "I") "exec firefox")
(define-key *root-map* (kbd "u") "mode-line")
(define-key *root-map* (kbd "b") "windowlist")
(define-key *root-map* (kbd "C-b") "windowlist")
(define-key *root-map* (kbd "b") "windowlist")
(define-key *root-map* (kbd "c") "term")
(define-key *root-map* (kbd "C-c") "term")
(define-key *root-map* (kbd "\C") "exec gnome-terminal")

(define-key *top-map* (kbd "M-`") "show-menu")
(define-key *top-map* (kbd "M-SPC") "dmenu")

;; ------------------------------------------------------------
;; Other configs

;; Mouse
(setf *mouse-focus-policy* :click)

;; Message Box
(setf *message-window-gravity* :center)
(setf *input-window-gravity* :center)

;; -----------------------------------------------------------
;; Modeline

;; (load-module "battery-portable")
;; (load-module "cpu")
;; (load-module "mem")
;; (load-module "wifi")
;; (load-module "stumptray")
;; (stumptray::stumptray)

;; Enable
(enable-mode-line (current-screen) (current-head) t)

;; Format
(setf *screen-mode-line-format* (list "%v"
                                      "^>"
                                      ;; "%C"
                                      ;; "%M"
                                      ;; "%I"
                                      ;; "%B"
                                      "%d"))
(setf *mode-line-border-width* 0)
(setf *mode-line-background-color* "#000809")
(setf *mode-line-foreground-color* "#D0D0D0")

;; Toggle
(defcommand mode-line () ()
  (toggle-mode-line (current-screen) (current-head)))

;; ------------------------------------------------------------
;; Custom commands for built-in or cli tooling (not modules)

(defcommand editrc () ()
  (run-shell-command "emacs ~/.stumpwmrc"))

(defcommand dmenu () ()
  (run-shell-command "dmenu_run"))

(defcommand term () ()
  "run gnome-terminal"
  (run-or-raise "gnome-terminal" '(:class "Gnome-terminal")))

(defcommand firefox () ()
  "run firefox"
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand spotify () ()
  "run spotify"
  (run-or-raise "spotify" '(:class "Spotify")))

(defcommand frescobaldi () ()
  "run frescobaldi"
  (run-or-raise "frescobaldi" '(:class "Frescobaldi")))

;; ------------------------------------------------------------
;; Modules
(add-to-load-path "/home/benwiz/.stumpwm.d/modules")

;; TODO Fonts
;; (load-module "ttf-fonts")

;; App Menu
(load-module "app-menu")

(setq app-menu:*app-menu* ;; Can create submenus but I don't think I need it
      '(("Firefox" firefox)
        ("Spotify" spotify)
        ("Frescobaldi" frescobaldi)
        ))

;; End Session
(load-module "end-session")
