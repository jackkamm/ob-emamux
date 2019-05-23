;;; ob-emamux.el --- org-babel tmux support via emamux -*- lexical-binding: t -*-

;; Author: Jack Kamm
;; Maintainer: Jack Kamm
;; Version: 0.1.0
;; Package-Requires: ((emacs "24.3") (emamux "0.14"))
;; Homepage: https://github.com/jackkamm/ob-emamux/
;; Keywords: comm, literate programming, tmux


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

;; Org-babel support for tmux via emamux.

;; Sends commands to external tmux sessions through org-babel source
;; blocks.  Integrated with TRAMP.  Doesn't require forwarding sockets.

;; An ob-emamux source block looks like this:

;; +#BEGIN_SRC emamux :session 0:0.0
;;      echo hello world
;; #+END_SRC

;; The :session parameter is specified as "session:window.pane".  If not
;; set to a specific session, it will use the default emamux target,
;; or prompt for one if this isn't set.

;; To configure emamux for tmux 2.0+, set
;; emamux:show-buffers-with-index to nil
;; and emamux:get-buffers-regexp to
;; "^\\(buffer[0-9]+\\): +\\([0-9]+\\) +\\(bytes\\): +[\"]\\(.*\\)[\"]"

;;; Code:

(require 'ob)
(require 'emamux)

(defvar org-babel-default-header-args:emamux
  '((:results . "silent"))
  "Default arguments to use when running emamux source blocks.")

(add-to-list 'org-src-lang-modes '("emamux" . sh))

(defun org-babel-execute:emamux (body params)
  "Execute a block of shell code with emamux and Babel.
This function is called by `org-babel-execute-src-block'.
BODY is the body of the source block and PARAMS is an alist
of the header properties."
  (let ((target (or (cdr (assq :session params))
                    (progn (when (not (emamux:set-parameters-p))
                             (emamux:set-parameters))
                           (emamux:target-session)))))
    (when (equal target "none") (error "Need a session to run"))
    (emamux:reset-prompt target)
    (emamux:send-keys body target)))

(provide 'ob-emamux)

;;; ob-emamux.el ends here
