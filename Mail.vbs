Dim ToAddress
Dim FromAddress
Dim MessageSubject
Dim MessageBody
Dim MessageAttachment
Dim ol, ns, newMail
ToAddress = "balraj52@gmail.com"
MessageSubject = "Today Snapshot"
MessageBody = ""
MessageAttachment = "C:\Users\HOME\Downloads\NSEDATA\OUTPUTS\NSEDAILY-en-us.PDF"
Set ol = WScript.CreateObject("Outlook.Application")
Set ns = ol.getNamespace("MAPI")
Set newMail = ol.CreateItem(olMailItem)
newMail.Subject = MessageSubject
newMail.Body = MessageBody & vbCrLf
newMail.RecipIents.Add(ToAddress)
newMail.Attachments.Add(MessageAttachment)
newMail.Send
ol.Quit