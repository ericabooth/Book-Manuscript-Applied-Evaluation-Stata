# Kaobook Full-Width and Margin Controls

The `kaobook` class has several built-in mechanisms to let you break out of the standard narrow-column/wide-margin layout when necessary.

## 1. For Specific Paragraphs or Text Blocks
If you want a specific section of text (like a wide code block or a long introduction) to span across both the main text area and the margin, wrap it in the `fullwidthpar` environment:
```latex
\begin{fullwidthpar}
This text will stretch across the entire page, ignoring the usual margin boundary. It's great for wide code blocks, large quotes, or long programmatic outputs where you don't need margin notes.
\end{fullwidthpar}
```

## 2. For Wide Figures and Tables
For large graphics, Stata outputs, or tables that need the full page width, use the "starred" versions of the environments (`figure*` and `table*`):
```latex
\begin{figure*}
    \includegraphics{images/my_wide_stata_plot.png}
    \caption{This caption and image will span the entire width of the page.}
\end{figure*}
```

## 3. For Entire Pages / Changing the Global Layout
To temporarily disable the margin entirely for a sequence of pages (e.g., in an appendix or large TOC), use these toggle commands:
```latex
\pagewidthpage % Turns off the wide margin and makes text full-width
... Your full-width content here ...
\normalmarginpage % Turns the wide margin back on
```

**Design Recommendation:** 
Since the "Embedded Evaluator" style relies heavily on marginalia (code snippets, side-notes, and call-out boxes), dropping into full-width mode is best reserved for visually dense moments—like displaying a complex Stata dataset screenshot, a wide event-study graph, or a massive regression table—before returning to the standard layout for narrative flow.
