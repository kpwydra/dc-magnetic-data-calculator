
# 🎨 --- UI helpers ------------------------------------------------------------
# Provides graphical elements (progress bars, message boxes, forms).
# Automatically falls back to console mode in CI or headless environments.
# Example:
#   $ui = New-ProgressForm -Title "Installer" -Max 4
#   Update-ProgressForm $ui 1 4 "Preparing..."
#   Close-ProgressForm $ui

$UIAvailable = $true
try {
    Add-Type -AssemblyName System.Windows.Forms -ErrorAction Stop
    [System.Windows.Forms.Application]::EnableVisualStyles()
} catch {
    Write-Warning "⚠️ GUI not available (server or CI mode). Console progress will be used."
    $UIAvailable = $false
}

function New-ProgressForm {
    param(
        [string]$Title = "GNU Make Installer",
        [int]$Max = 4
    )

    # --- Fallback: console-only mode (no GUI) --------------------------------
    if (-not $UIAvailable) {
        $progress = [PSCustomObject]@{
            Step  = 0
            Max   = $Max
            Label = "Preparing..."
            Update = {
                param($text)
                $this.Step++
                $percent = [math]::Round(($this.Step / $this.Max) * 100)
                Write-Host ("[{0,2}/{1}] {2,-25} ({3,3}%)" -f $this.Step, $this.Max, $text, $percent)
            }
            Close = { Write-Host "✔️  Installation completed." }
        }
        $progress.Update.Invoke("Starting in console mode...")
        return $progress
    }

    # --- GUI mode ------------------------------------------------------------
    $form = New-Object System.Windows.Forms.Form
    $form.Text = $Title
    $form.Width = 540; $form.Height = 180
    $form.StartPosition = "CenterScreen"
    $form.FormBorderStyle = "FixedDialog"
    $form.MaximizeBox = $false
    $form.MinimizeBox = $false
    $form.TopMost = $true
    $form.BackColor = [System.Drawing.Color]::FromArgb(245,245,245)

    # Label
    $label = New-Object System.Windows.Forms.Label
    $label.Width = 500; $label.Height = 30
    $label.Left = 20; $label.Top = 20
    $label.Font = New-Object System.Drawing.Font("Segoe UI", 10,[System.Drawing.FontStyle]::Regular)
    $label.Text = "Preparing installer..."

    # ProgressBar
    $bar = New-Object System.Windows.Forms.ProgressBar
    $bar.Left = 20; $bar.Top = 60
    $bar.Width = 480; $bar.Height = 25
    $bar.Style = "Continuous"
    $bar.Minimum = 0; $bar.Maximum = $Max; $bar.Value = 0

    # Cancel button
    $btnCancel = New-Object System.Windows.Forms.Button
    $btnCancel.Text = "Cancel"
    $btnCancel.Left = 400; $btnCancel.Top = 100
    $btnCancel.Width = 100; $btnCancel.Height = 30
    $btnCancel.Add_Click({
        $form.Tag = "Cancelled"
        $form.Close()
    })

    # Add controls
    $form.Controls.AddRange(@($label, $bar, $btnCancel))

    # --- Return composite object ---------------------------------------------
    return [PSCustomObject]@{
        Form   = $form
        Label  = $label
        Bar    = $bar
        Cancel = $btnCancel
        Update = {
            param($text)
            $this.Bar.PerformStep()
            $this.Label.Text = $text
            $this.Form.Refresh()
        }
        Close = {
            if ($this.Form.Tag -ne "Cancelled") {
                $this.Label.Text = "Installation complete."
                Start-Sleep -Milliseconds 800
            }
            $this.Form.Close()
        }
    }
}


# 📊 --- Progress UI & Control Helpers -----------------------------------------
# Manages the installer progress interface (window or console).
# Handles creation, updates, and closing of the progress form created by New-ProgressForm.
# Works in both GUI and console fallback modes.
# Example:
#   $ui = New-ProgressForm -Title "GNU Make Installer" -Max 4
#   if ($ui.Form) { $ui.Form.Show() }
#   Update-ProgressForm $ui 2 4 "Installing components..."
#   Close-ProgressForm  $ui

function Update-ProgressForm($Ui, [int]$Step, [int]$Total, [string]$Msg) {
    if (-not $Ui) { return }

    # --- GUI mode ------------------------------------------------------------
    if ($Ui.Form -ne $null) {
        try {
            $Ui.Label.Text = $Msg
            $Ui.Bar.Maximum = $Total
            $Ui.Bar.Value   = [Math]::Min($Step, $Total)
            $Ui.Form.Refresh()
        } catch {
            Write-Warning "Failed to update progress form: $_"
        }
    }
    # --- Console fallback ----------------------------------------------------
    else {
        $percent = [math]::Round(($Step / $Total) * 100)
        Write-Host ("[{0,2}/{1}] {2,-25} ({3,3}%)" -f $Step, $Total, $Msg, $percent)
    }
}

function Close-ProgressForm($Ui) {
    if (-not $Ui) { return }

    if ($Ui.Form -ne $null) {
        try {
            $Ui.Close.Invoke()
        } catch {
            Write-Warning "Failed to close progress form: $_"
        }
    }
    else {
        Write-Host "✔️  Installation completed."
    }
}
