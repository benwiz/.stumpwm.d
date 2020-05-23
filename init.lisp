(in-package :stumpwm)

(require :swank)
(swank-loader:init)
(swank:create-server :port 4005
                     :style swank:*communication-style*
                     :dont-close t)

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
(define-key *top-map* (kbd "M-`") "show-menu")
(define-key *root-map* (kbd "m") "show-desktop-menu")

;; ------------------------------------------------------------
;; Other configs

;; Mouse
(setf *mouse-focus-policy* :click)

;; Message Box
(setf *message-window-gravity* :top-right)
(setf *input-window-gravity* :center)

;; Modeline (not yet convinced of its value)
;; (enable-mode-line (current-screen) (current-head) t (list "%w |" '(:eval (run-shell-command "date" t))))
;; (toggle-mode-line (current-screen) (current-head))

;; TODO fonts

;; ------------------------------------------------------------
;; Custom commands

;; Edit this file
(defcommand editrc () ()
  (run-shell-command "emacs ~/.stumpwmrc"))

;; TODO delete this after testing `end-session` cmd
;; ;; Shutdown / Reboot
;; (defun shutdown-fn (type passwd)
;;   "Calls the shutdown command with the specified halting operation and the password"
;;   (let* ((shutdown-type (case type
;;                           (:halt "-h")
;;                           (:reboot "-r")))
;;          (command (concatenate 'string "echo " passwd " | sudo -S shutdown " shutdown-type " now")))
;;     (run-shell-command command)))

;; (defcommand shutdown (passwd) ((:string "please enter your password: "))
;;   (shutdown-fn :halt passwd))

;; (defcommand reboot (passwd) ((:string "please enter your password: "))
;;   (shutdown-fn :reboot passwd))

;; ------------------------------------------------------------
;; Modules
(add-to-load-path "/home/benwiz/.stumpwm.d/modules")

;; App Menu
(load-module "app-menu")

(defcommand firefox () ()
  "run firefox"
  (run-or-raise "firefox" '(:class "Firefox")))

(defcommand frescobaldi () ()
  "run frescobaldi"
  (run-or-raise "frescobaldi" '(:class "Frescobaldi")))

(setq app-menu:*app-menu* ;; Can create submenus but I don't think I need it
      '(("Firefox" firefox)
        ("Frescobaldi" frescobaldi)
        ))

;; Desktop Entry
(load-module "desktop-entry")
(desktop-entry:init-entry-list)

;; End Session
(load-module "end-session")
