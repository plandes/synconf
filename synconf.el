;; Emacs Configuration for use with the choice-program Emacs module
;; https://github.com/plandes/choice-program
;; Add the contents of this file your ~/.emacs to get the integration.

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
