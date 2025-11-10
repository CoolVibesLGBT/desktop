package main

import webview "github.com/webview/webview_go"

func main() {
	debug := false
	w := webview.New(debug)
	defer w.Destroy()
	w.SetTitle("CoolVibes LGBTIQ Social Media App")
	w.SetSize(1024, 768, webview.HintNone)
	w.Navigate("https://coolvibes.lgbt")
	w.Run()
}
