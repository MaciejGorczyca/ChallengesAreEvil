using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace ChallengesAreEvil
{
    public partial class ChallengesAreEvilForm : Form
    {

        LeagueConnection lc;
        
        public ChallengesAreEvilForm()
        {
            InitializeComponent();
        }

        private void ChallengesAreEvilForm_Load(object sender, EventArgs e)
        {
            lc = new LeagueConnection();
        }

        private void editMessageLabel(String msg)
        {
            messageLabel.Text = msg;
        }

        private Boolean checkIfLeagueIsConnected()
        {
            if (!lc.IsConnected)
            {
                editMessageLabel("Not connected to League Client! You need to log in first and wait few seconds.");
                return false;
            }
            return true;
        }

        private void removeTokensButton_Click(object sender, EventArgs e)
        {
            if (checkIfLeagueIsConnected())
            {
                lc.Post("/lol-challenges/v1/update-player-preferences/", "{\"challengeIds\": []}");
                editMessageLabel("Tokens removed from profile banner.");
            }
        }

        private void checkHextechButBetterButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show(
                @"The browser will now open.");
            System.Diagnostics.Process.Start("https://github.com/MaciejGorczyca/HextechButBetter");
        }

        private void checkLeagueUnglitchButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show(
                @"The browser will now open.");
            System.Diagnostics.Process.Start("https://github.com/MaciejGorczyca/League-Unglitch");
        }

        private void legalNoteButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show("ChallengesAreEvil isn’t endorsed by Riot Games and doesn’t reflect the views or opinions of Riot Games or anyone officially involved in producing or managing League of Legends. League of Legends and Riot Games are trademarks or registered trademarks of Riot Games, Inc. League of Legends © Riot Games, Inc.");
        }

        private void donateButton_Click(object sender, EventArgs e)
        {
            MessageBox.Show(
@"The browser will now open.
                            
Thank you for considering donation!
The software is completely free to use for everyone.
If you wish to thank me and help me back, feel free to send me even the smallest possible amount.
                            
I will greatly appreciate your goodwill!");
            System.Diagnostics.Process.Start("https://www.paypal.me/CoUsTme/1EUR");
        }
    }
}