\RequirePackage{expl3}

\ProvidesExplClass{projectproposal}{2022-11-24}{1.1.0}{Small class for creating project proposals of the Institute of Theoretical Chemistry}

\ProcessOptions\relax

\LoadClass[parskip=half]{scrartcl}

\RequirePackage[top=2cm, left=1.8cm, right=1.8cm, bottom=2cm]{geometry}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{xcolor}
\RequirePackage{xparse}
\RequirePackage{iflang}
\RequirePackage{hyperref}

\definecolor{anthrazit}{RGB}{62,68,76}
\definecolor{mittelblau}{RGB}{0,81,158}
\definecolor{hellblau}{RGB}{0,190,255}

\clist_new:N \projectproposal_keywords_clist
\tl_new:N \projectproposal_project_type_tl
\tl_new:N \projectproposal_supervisor_tl
\tl_new:N \projectproposal_supervisor_email_tl
\tl_new:N \projectproposal_examiner_tl
\tl_new:N \projectproposal_keywords_localization_tl
\tl_new:N \projectproposal_project_type_localization_tl
\tl_new:N \projectproposal_supervisor_localization_tl
\tl_new:N \projectproposal_examiner_localization_tl
\tl_new:N \projectproposal_logo_path_tl
\tl_new:N \projectproposal_logo_subtitle_tl
\fp_new:N \projectproposal_logo_subtitle_y_factor_fp
\fp_new:N \projectproposal_logo_subtitle_x_factor_fp
\bool_new:N \projectproposal_is_german_bool

% Make all section-like contents use our special color
\addtokomafont{disposition}{\color{mittelblau}}

\NewDocumentCommand{\boldText}{ m }{
	{\color{mittelblau} \textbf{#1}}
}

\NewDocumentCommand{\keywords}{ m }{
	\clist_set:Nn \projectproposal_keywords_clist {#1}
}

\NewDocumentCommand{\projectType}{ m }{
	\tl_set:Nn \projectproposal_project_type_tl {#1}
}

\NewDocumentCommand{\supervisor}{ m }{
	\tl_set:Nn \projectproposal_supervisor_tl {#1}
}

\NewDocumentCommand{\supervisorEmail}{ m }{
	\tl_set:Nn \projectproposal_supervisor_email_tl {#1}
}

\NewDocumentCommand{\examiner}{ m }{
	\tl_set:Nn \projectproposal_examiner_tl {#1}
}

% Remove page numbers
\AtBeginDocument{\pagestyle{empty}}

% Check language
\AtBeginDocument{
	\IfLanguageName{german}{\bool_set_true:N \projectproposal_is_german_bool}{}
	\IfLanguageName{ngerman}{\bool_set_true:N \projectproposal_is_german_bool}{
		% default
		\bool_set_false:N \projectproposal_is_german_bool
	}
}

% Overwrite \maketitle with our own, custom stuff
\AtBeginDocument{
	\bool_if:nTF \projectproposal_is_german_bool {
		\tl_set:Nn \projectproposal_keywords_localization_tl {Stichworte}
		\tl_set:Nn \projectproposal_project_type_localization_tl {Projektart}
		\tl_set:Nn \projectproposal_supervisor_localization_tl {Betreuer}
		\tl_set:Nn \projectproposal_examiner_localization_tl {Prüfer}
		\tl_set:Nn \projectproposal_logo_path_tl {images/logo_unistuttgart_deutsch_weiss.eps}
		\tl_set:Nn \projectproposal_logo_subtitle_tl {Institut~für~Theoretische~Chemie}
		\fp_set:Nn \projectproposal_logo_subtitle_x_factor_fp {0.25}
		\fp_set:Nn \projectproposal_logo_subtitle_y_factor_fp {-0.85}
	}{
		\tl_set:Nn \projectproposal_keywords_localization_tl {Keywords}
		\tl_set:Nn \projectproposal_project_type_localization_tl {Project~type}
		\tl_set:Nn \projectproposal_supervisor_localization_tl {Supervisor}
		\tl_set:Nn \projectproposal_examiner_localization_tl {Examiner}
		\tl_set:Nn \projectproposal_logo_path_tl {images/logo_university_stuttgart_white.eps}
		\tl_set:Nn \projectproposal_logo_subtitle_tl {Institute~for~Theoretical~Chemistry}
		\fp_set:Nn \projectproposal_logo_subtitle_x_factor_fp {0.24}
		\fp_set:Nn \projectproposal_logo_subtitle_y_factor_fp {-1.2}
	}

	\renewcommand*{\maketitle}{
		\newsavebox\projectproposal_logo_box
		\newlength\projectproposal_logo_height
		\newlength\projectproposal_logo_width
		\newlength\projectproposal_logo_subtitle_font_size

		\begin{tikzpicture}[remember~picture, overlay]
			\def\titleBubbleRadius{0.5\paperwidth}
			\def\titleBubbleOffsetX{0.2\paperwidth}
			\def\titleBubbleOffsetY{0.18\paperwidth}
			\def\titleOffsetX{0.05\paperwidth}
			\def\logoBubbleRadius{0.25\paperwidth}
			\def\logoBubbleOffsetX{-0.2\paperwidth}
			\def\logoBubbleOffsetY{-0.05\paperwidth}

			% Clip at paper borders
			\clip (current~page.north~west) -- ++(\paperwidth, 0) -- ++(0, -\paperheight) -- ++(-\paperwidth, 0) -- cycle;

			\path (current~page.north~west) ++(\titleBubbleOffsetX, \titleBubbleOffsetY) coordinate (titleBubbleCenter);
			\path (current~page.north~west) ++({\titleBubbleRadius - \titleBubbleOffsetX + \titleOffsetX},
				{-0.35*(\titleBubbleRadius-\titleBubbleOffsetY)}) coordinate (titleCenter);

			\path (current~page.north~east) ++(\logoBubbleOffsetX, \logoBubbleOffsetY) coordinate(logoBubbleCenter);
			\path (current~page.north~east) ++({-0.5*(\logoBubbleRadius - \logoBubbleOffsetX)},
				{-0.35*(\logoBubbleRadius - \logoBubbleOffsetY)}) coordinate(logoCenter);

			\fill[hellblau] (titleBubbleCenter) circle[radius=\titleBubbleRadius];
			\path (titleCenter) node[text~width={0.8*(2*\titleBubbleRadius - \titleBubbleOffsetX - \titleOffsetX)}] {
				\begin{flushleft}
					\huge\textbf{\@title}
				\end{flushleft}
			};

			\savebox\projectproposal_logo_box{\includegraphics[width=.35\paperwidth]\projectproposal_logo_path_tl}
			\settoheight\projectproposal_logo_height{\usebox\projectproposal_logo_box}
			\settowidth\projectproposal_logo_width{\usebox\projectproposal_logo_box}
			\setlength\projectproposal_logo_subtitle_font_size{0.25\projectproposal_logo_height}

			\fill[mittelblau] (logoBubbleCenter) circle[radius=\logoBubbleRadius];
			\path (logoCenter) node[outer~sep=0pt, inner~sep=0pt] (logo) {\usebox\projectproposal_logo_box};

			% Add logo subtitle
			\path (logo.north~west) ++({\fp_use:N \projectproposal_logo_subtitle_x_factor_fp*\projectproposal_logo_width},
				{\fp_use:N \projectproposal_logo_subtitle_y_factor_fp*\projectproposal_logo_height})
				node[right, white] {\fontsize{\projectproposal_logo_subtitle_font_size}{0pt}\selectfont\textsf{\projectproposal_logo_subtitle_tl}};
		\end{tikzpicture}

		\vspace{.2\paperwidth}

		\begin{center}
			\begin{tabular}{l@{\hspace{1cm}} l@{\hspace{1cm}} l}
				\boldText{\projectproposal_project_type_localization_tl} & \boldText{\projectproposal_supervisor_localization_tl}:
					& \boldText{\projectproposal_examiner_localization_tl}: \\
				\projectproposal_project_type_tl
					& \projectproposal_supervisor_tl \tl_if_blank:eTF \projectproposal_supervisor_email_tl {} {$^*$}
				    & \projectproposal_examiner_tl
			\end{tabular}

			\\

			\tl_if_blank:eTF \projectproposal_supervisor_email_tl {}{
				\vspace{4mm}

				{\scriptsize $^*$\texttt{\href{mailto:\projectproposal_supervisor_email_tl}{\projectproposal_supervisor_email_tl}}}
			}
		\end{center}

		\clist_if_empty:NTF \projectproposal_keywords_clist {}{
			\boldText{\projectproposal_keywords_localization_tl :}~ \clist_use:Nnnn \projectproposal_keywords_clist {~$\diamond{}$~}{~$\diamond{}$~}{~$\diamond{}$~}
		}
	}
}
