;;; synconf.el --- This program will synchronize data using rsync

;; Copyright (C) 2017 Paul Landes

;; Version: 0.1
;; Author: Paul Landes
;; Maintainer: Paul Landes
;; Keywords: rsync synchronize sync
;; URL: https://github.com/plandes/synconf
;; Package-Requires: ((emacs "24.5"))

;; This file is not part of GNU Emacs.

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;; Emacs Configuration for use with the choice-program Emacs module
;; https://github.com/plandes/choice-program
;; Add the contents of this file your ~/.emacs to get the integration.

;;; Code:

(require 'choice-program)

;;; synconf
(defvar synconf-the-instance
  (choice-prog nil
	       :program "synconf"
	       :interpreter "perl"
	       :buffer-name "*Synchronized Output*"
	       :choice-prompt "Mnemonic"
	       :choice-switch-name "-m"
	       :selection-args '("-a" "listmnemonics")
	       :documentation
"Run a synchronize command.  The command is issued with the `synconf'
perl script.")
  "The synconf object instance.")

;;;###autoload
(defun synconf (&optional rest) (interactive))
(choice-prog-create-exec-function 'synconf-the-instance)

(provide 'synconf)

;;; synconf.el ends here
