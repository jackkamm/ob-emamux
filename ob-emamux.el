;;; ob-emamux.el --- Tmux blocks for org-babel -*- lexical-binding: t -*-

;; Author: Jack Kamm
;; Maintainer: Jack Kamm
;; Version: 0.1.0
;; Package-Requires: (emamux)
;; Homepage: TODO
;; Keywords: TODO


;; This file is not part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; For a full copy of the GNU General Public License
;; see <http://www.gnu.org/licenses/>.


;;; Commentary:

;; TODO

;;; Code:

(require 'ob)
(require 'emamux)

(defvar org-babel-default-header-args:emamux
  '((:results . "silent"))
  "Default arguments to use when running emamux source blocks.")

(add-to-list 'org-src-lang-modes '("emamux" . sh))

(defun org-babel-execute:emamux (body params)
  "TODO"
  (let ((target (or (cdr (assq :session params))
                    (progn (when (not (emamux:set-parameters-p))
                             (emamux:set-parameters))
                           (emamux:target-session)))))
    (when (equal target "none")
      (error "Need a session to run"))
    (emamux:reset-prompt target)
    (emamux:send-keys body target)))

(provide 'ob-emamux)

;;; ob-emamux.el ends here
