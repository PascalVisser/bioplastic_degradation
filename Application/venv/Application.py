#! usr/bin/env python3

import tkinter as tk
from tkinter import filedialog, Text
from PIL import ImageTk, Image
from csv import reader
import os
import ctypes
import time

myappid = 'mycompany.myproduct.subproduct.version' # arbitrary string
ctypes.windll.shell32.SetCurrentProcessExplicitAppUserModelID(myappid)

root = tk.Tk()
root.iconbitmap("Hanze_logo.ico")
apps = []
stats = []

# creates select folder option
def selectFiles():

    for widget in frame.winfo_children():
        widget.destroy()

    files = filedialog.askdirectory(initialdir="/")
    apps.append(files)
    label = tk.Label(frame, text = files, bg="gray")
    label.pack()

#fileButton = tk.Button(root, text="Open files", padx=10, pady=5, fg="white", command=selectFiles())
#fileButton.pack(side="bottom")
workdir = filedialog.askdirectory(initialdir="/")
config_file = f"*config file {workdir}"
# run the pipeline
os.system("snakefile command")

images = []

with open("csv_file", "r") as read_obj:
    # open csv object
    csv_reader = reader(read_obj)
    # create empty list
    result = []
    # creates blanks for first results as their is no fsc or ssc change at time = 0
    for i in range(3):
        result.append("-")
    for row in csv_reader:
        for item in row.split(","):
            # add all statistics of the row
            result.append(item)
        # Adds resutls to bigger statistics list
        stats.append(result)
        result = []

# loops through pictures to create the same amount of results
for i, file in enumerate(os.listdir("Pictures/")):
    root.columnconfigure(i, weight=1, minsize=75)
    root.rowconfigure(i, weight=1, minsize=50)
    frame1 = tk.Frame(
        master=root,
        relief=tk.RAISED,
        borderwidth=1
    )
    frame1.grid(row=i, column=0, padx=5, pady=5)
    img = ImageTk.PhotoImage(Image.open(f"Pictures/{file}").resize((150, 125), Image.ANTIALIAS))
    images.append(img)
    label = tk.Label(master=frame1, image=images[i])
    label.pack()

    stat = stats[i]
    frame2 = tk.Frame(
        master=root,
        relief=tk.RAISED,
        borderwidth=1
    )
    frame2.grid(row=i, column=1, padx=5, pady=5)
    label = tk.Label(master=frame2, text=f"Statistic at time = {i}\n"
                                         f"Forward scatter change: {stat[0]}%\n"
                                         f"Sideward scatter change: {stat[1]}%\n"
                                         f"Vector movement: {stat[2]}%\n"
                                         f"Quality check\n"
                                         f"Silhouette score: {stat[3]}\n"
                                         f"Points clustered: {stat[4]}%")
    label.pack()

root.mainloop()
