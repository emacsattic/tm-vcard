;;; tm-vcard --- allow TM (and hence Gnus, RMAIL, et al) to display a vcard MIME part
;;
;; Copyright (C) 1998 Andrew J Cosgriff
;;
;; Author: Andrew J Cosgriff <ajc@bing.wattle.id.au>
;; Created: Fri Aug  7 10:56:16 1998
;; Version: $Id: tm-vcard.el,v 1.1 1998/08/17 23:02:23 ajc Exp $
;; URI: http://bing.bofh.asn.au/sw/emacs-lisp/
;; Keywords: tm vcard gnus rmail mime
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Commentary:
;;
;; Noah Friedman wrote a generic bit of Emacs Lisp to parse VCard
;; data, saying "it'd be neat if somebody made this work with TM, so
;; Gnus and RMAIL can use it." - here goes...
;;
;; You'll need to get vcard.el from
;; http://www.splode.com/users/friedman/software/emacs-lisp/
;;
;; Once it's all installed, you can add something like
;;
;; (call-after-loaded 'tm-view (function (lambda () (require 'tm-vcard) (tm-vcard-install))))
;;
;; to activate it
;;
;; This code is available from http://bing.bofh.asn.au/sw/emacs-lisp/
;;
;;; TO DO:
;;
;; - buttonize things like email addresses and web pages (I think this
;;   is gnus-specific, so I'm not sure how it ought to be done)
;;
;; - BBDB ?
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; History:
;;
;; 1.1 - Initial version - show the vcard stuff in a separate buffer.
;;
;; 1.2 - show the vcard stuff in the same buffer.  much better !
;;
;; 1.3-1.5 - misc. fixes and prettying up for general release.
;;
;; 1.6 - I forgot that I'm not meant to automatically do stuff upon
;;       loading, so you have to call (tm-vcard-install) now.
;;
;; 1.7 - Tell vcard-parse-string to use the standard filters, which
;;       currently means HTML gets stripped.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;;; Code:
;;
(require 'tm-view)
(require 'vcard)

(defun mime-preview/filter-for-text/x-vcard (ctype params encoding)
  (let* ((mode mime::preview/original-major-mode)
	 (m (assq mode mime-viewer/code-converter-alist))
	 (charset (cdr (assoc "charset" params)))
	 (beg (point-min))
	 (str (buffer-substring beg (point-max))))
    (delete-region beg (point-max))
    (insert (vcard-format-string (vcard-parse-string str 'vcard-standard-filter)) "\n")
    (mime-preview/decode-text-buffer charset encoding)))

(defun tm-vcard-install ()
  (interactive)
  (if (not (member "text/x-vcard" mime-viewer/default-showing-Content-Type-list))
      (setq mime-viewer/default-showing-Content-Type-list
	    (append mime-viewer/default-showing-Content-Type-list
		    '("text/x-vcard"))))
  
  (if (not (member '("text/x-vcard" . mime-preview/filter-for-text/x-vcard) mime-viewer/content-filter-alist))
      (setq mime-viewer/content-filter-alist
	    (append '(("text/x-vcard" . mime-preview/filter-for-text/x-vcard))
		    mime-viewer/content-filter-alist))))

(provide 'tm-vcard)
;;; tm-vcard.el ends here